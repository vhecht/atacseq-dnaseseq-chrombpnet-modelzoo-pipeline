import argparse
import os
import sys
import pandas as pd
import subprocess
from pandas.errors import EmptyDataError
from pathlib import Path
from typing import Optional, List
from pyfaidx import Fasta
import logging


def get_logger(log_file:Path) -> logging.Logger:
    """Initialize and configure the logger with a given log_file path"""
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s | %(levelname)s | %(message)s')

    stdout_handler = logging.StreamHandler(sys.stdout)
    stdout_handler.setLevel(logging.DEBUG)
    stdout_handler.setFormatter(formatter)

    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(stdout_handler)

    return logger


def get_ccre_regions(peaks_to_fill: Path, final_regions: Path, fdr_merged_bed:Path, logger, bed_dir_int: Path,
                     ccre_in_bed: Path) -> pd.DataFrame:
    """Collects additional regions from ccREs not already found in list of peaks
    Args:
        peaks_to_fill: temporary file with peaks not in the original 100K peaks file,
        but that did pass the fdr_threshold
        final_regions: output file with ccREs appended to peaks_to_fill following
        bedtools intersect, merge, etc
        fdr_merged_bed: set of merged regions of top 100K peaks + additional regions passing FDR threshold
        logger: to keep track of outputs
        bed_dir_int: parent directory of all output files (intermediate and final)
        ccre_in_bed: path to ccre bed.gz file (downloaded via download_ccres.sh)
    """
    ccre_regions_preformatted = bed_dir_int / "cre.reformat.bed"

    # do the usual bedtools intersect to find regions in the ccRE list which are not already represented in
    # the regions in fdr_merged_bed
    #TODO: does ccre_in_bed need to be sorted first?
    command = (f"bedtools intersect -v -wa -a {ccre_in_bed} -b {fdr_merged_bed} | sort | uniq | "
               f"grep -v \"Low-DNase\" > {ccre_regions_preformatted}")
    exit_code = os.system(command)
    logger.info(command)
    assert exit_code == 0, f"Error in {command}"

    # were any ccREs added to the regions list? (i.e. `ccre_regions_preformatted` file is non-empty)
    if os.stat(ccre_regions_preformatted).st_size > 0:
        bed_ccre = pd.read_csv(ccre_regions_preformatted, sep="\t", header=None)
        # not sure if this if statement is necessary -- feels redundant with the os.stat
        logger.info(f"bed_ccre.shape[0]: {bed_ccre.shape[0]}")
        if bed_ccre.shape[0] >= 1:
            bed_ccre_new = pd.DataFrame()
            for idx in range(0, 3):
                bed_ccre_new[idx] = bed_ccre[idx]
            for idx in range(3, 9):
                bed_ccre_new[idx] = '.'
            bed_ccre_new[9] = ((bed_ccre[1] + bed_ccre[2]) // 2) - bed_ccre[1]

            if os.stat(peaks_to_fill).st_size > 0:
                logger.info(f"combine in python {peaks_to_fill} and {ccre_regions_preformatted}")
                old_bed = pd.read_csv(peaks_to_fill, sep="\t", header=None)
                final_bed = pd.concat([bed_ccre_new, old_bed])
            else:
                logger.info(f"empty {peaks_to_fill}, use only {ccre_regions_preformatted}")
                final_bed = bed_ccre_new
            final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')
    else:
        if os.stat(peaks_to_fill).st_size > 0:
            logger.info(f"empty {peaks_to_fill}, use only {ccre_regions_preformatted}")
            old_bed = pd.read_csv(peaks_to_fill, sep="\t", header=None)
            final_bed = old_bed
        else:
            logger.info(f"both {ccre_regions_preformatted} and {peaks_to_fill} empty")
            final_bed = pd.DataFrame()
        final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')

    return final_bed


def get_valid_sequences(peaks_df: pd.DataFrame, genome_fa: Fasta, width=2114):
    """Check that all peaks in peaks_df sit on a valid portion of a chromosome in the provided genome
    Args:
        peaks_df: data frame of peaks to check
        genome_fa: genome to compare against
        width: size of region (don't change this!)
    """
    # Recall: NARROWPEAK_SCHEMA = ["chr", "start", "end", "1", "2", "3", "4", "5", "6", "summit"]
    #peaks_used: list = [False] * peaks_df.shape[0]
    peaks_used = []
    for index, row in peaks_df.iterrows():
        sequence = genome_fa[row[0]][(row[1]+row[9] - width//2):(row[1] + row[9] + width//2)]
        if len(sequence) == 2114:
            #peaks_used[index] = True
            peaks_used.append(True)
        else:
            peaks_used.append(False)
    return peaks_used


def main(full_peak_bed: Path,
         bed_file: Path,
         bed_dir_int: Path,
         ccre_in_bed: Optional[Path],
         remove_temp_files: bool,
         genome_in: Path):
    """Using called peaks and regions from CCREs, define regions to be used for interpret step
	Args:
		encid: list of ENCIDs to process
		full_peak_bed: path to location of peaks.bed.gz. For example,
		outdir / f"{encid}/preprocessing/downloads/peaks.bed.gz"
		bed_file: path to top 100K peaks, with suffix `100K.ranked.subsample.overlap.bed`,
		e.g. $OAK_HOME/chromatin-atlas-2022/DNASE/{encid}/
		preprocessing/downloads/100K.ranked.subsample.overlap.bed
		bed_dir_int: directory for storing output files
		ccre_in_bed: location of ccRE (downloaded in download_ccres.sh)
		remove_temp_files: should temporary files be removed?
		genome_in: path to genome fasta
	"""
    temp_file = bed_dir_int / "100K.ranked.merged.bed.gz"
    output_file_extra = bed_dir_int / "extra_new.regions.bed.gz"
    output_file_extra_temp = bed_dir_int / "extra.temp.regions.bed"

    output_file_all = bed_dir_int / "selected_new.regions.bed.gz"
    output_file_all_valid = bed_dir_int / "selected_new.valid.regions.bed.gz"
    output_file_merged = bed_dir_int / "selected_new.regions.merged.bed.gz"
    log_file = bed_dir_int / "selected_new_regions.log"

    temp_fdr = bed_dir_int / "fdr.cutoff.peaks.bed.gz"
    temp_file_2 = bed_dir_int / "fdr.cutoff.peaks.merged.bed"
    temp_peaks_filled = bed_dir_int / "fdr.filled.peaks.bed.gz"

    logger = get_logger(log_file)

    output_v = subprocess.check_output("bedtools --version", shell=True)
    logger.info(f"bedtools --version: {output_v}")

    # sort input peaks by chromosome and position, then combine overlapping features
    command = f"bedtools sort -i {bed_file} | bedtools merge -i stdin | gzip > {temp_file}"
    logger.info(command)
    exit_code = os.system(command)

    assert exit_code == 0, f"Error in {command}"

    peaks = pd.read_csv(full_peak_bed, sep="\t", header=None)

    # temp file fdr thresholded
    logger.info(f"peaks # of rows: {peaks.shape[0]}")
    fdr_1 = peaks[peaks[8] > 2]
    logger.info(f"# of peaks with -log10(FDR) threshold > 2: {fdr_1.shape[0]}")
    logger.info("filter peaks based on FDR, 8th column > 2")

    fdr_1.to_csv(temp_fdr, header=False, index=False, sep="\t")

    # get peak regions to fill regions
    command = f"bedtools intersect -v -wa -a {temp_fdr} -b {temp_file} | sort | uniq > {output_file_extra_temp}"
    logger.info(command)
    exit_code = os.system(command)
    assert exit_code == 0, (f"Nonzero exit code for {command}")

    try:
        df1 = pd.read_csv(output_file_extra_temp, sep="\t", header=None)
        #TODO: why bed_file here and not temp_file?
        bed_file_df = pd.read_csv(bed_file, sep="\t", header=None)
        df3 = pd.concat([df1, bed_file_df])
    except:
        bed_file_df = pd.read_csv(bed_file, sep="\t", header=None)
        df3 = bed_file_df

    # df3[1] = start index, df3[2] = end index, df[3] = peak summit (bases away from start)
    # redefine region as 1000 bp window centered at peak summit
    df3[2] = df3[1] + df3[9] + 500
    df3[1] = df3[1] + df3[9] - 500
    # replace any value less than zero with zero
    df3[1] = df3[1].clip(0)
    df3.to_csv(temp_peaks_filled, sep="\t", header=False, index=False)

    # recall: df_3 roughly = union(peaks passing fdr thresh, top 100 peaks); fdr_1 = peaks passing fdr thresh
    if df3.shape[0] < fdr_1.shape[0]:
        command = f"bedtools sort -i {temp_peaks_filled} |  bedtools merge -i stdin > {temp_file_2}"
    else:
        # TODO: under what circumstances is this step run?
        command = "gunzip -c " + str(temp_fdr) + (
            "| awk -v FS=\'\\t\' -v OFS=\'\\t\'  \'{print $1,$2+$10-500,$2+$10+500,$4,"
            "$5,$6,$7,$8, $9, $10}\' | awk  -v FS=\'\\t\' -v OFS=\'\\t\'  '$2<0 {"
            "$2=0} 1' | bedtools sort -i stdin |  bedtools merge -i stdin > "
            "") + str(temp_file_2)
    logger.info(command)
    exit_code = os.system(command)
    assert exit_code == 0, (f"Nonzero exit code for {command}")

    if ccre_in_bed is not None:
        # get ccre regions to fill
        extras = get_ccre_regions(
            ccre_in_bed=ccre_in_bed,
            peaks_to_fill=output_file_extra_temp,
            bed_dir_int=bed_dir_int,
            final_regions=output_file_extra,
            logger=logger,
            fdr_merged_bed=temp_file_2
        )
    else:
        logger.info(f"No ccres available. Using {output_file_extra_temp} as extra peaks.")
        if os.stat(output_file_extra_temp).st_size > 0:
            extras = pd.read_csv(output_file_extra_temp, sep="\t", header=None)
        else:
            logger.info(f"{output_file_extra_temp} also empty.")
            extras = pd.DataFrame()
        extras.to_csv(output_file_extra, header=False, index=False, sep="\t", compression='gzip')

    try:
        final_regions = pd.concat([bed_file_df, extras])
        final_regions.to_csv(output_file_all, sep="\t", header=False, index=False, compression="gzip")
        command = f'concat in python {output_file_extra} {bed_file} to get {output_file_all}'
        logger.info(command)
    except EmptyDataError:
        command = f"cp {bed_file} {output_file_all}"
        final_regions = bed_file_df
        os.system(command)
        logger.info(f"No {output_file_extra}. Using {command}")

    command = f"bedtools sort -i {output_file_all} | bedtools merge -i stdin | gzip > {output_file_merged}"
    exit_code = os.system(command)
    logger.info(command)
    assert exit_code == 0, f"Error in {command}"

    # get valid regions
    genome_fa = Fasta(genome_in)
    keep_peaks: List[bool] = get_valid_sequences(peaks_df=final_regions, genome_fa=genome_fa)
    logger.info(f"Keeping {sum(keep_peaks)} valid peaks out of {len(keep_peaks)} total peaks")
    final_regions[keep_peaks].to_csv(output_file_all_valid, sep="\t", header=False, index=False, compression="gzip")

    # remove all temporary files
    if remove_temp_files:
        command = f"rm {temp_file} {temp_file_2} {output_file_extra_temp} {temp_fdr} {temp_peaks_filled}"
        os.system(command)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate peaks for DNase interpret regions")
    parser.add_argument("--full_peak_bed", type=str, required=True, help="path to location of peaks.bed.gz")
    parser.add_argument("--bed_file", type=str, help="path to 100K.ranked.subsample.overlap.bed", required=True)
    parser.add_argument("--bed_dir_int", type=str, help="directory for storing output files", required=True)
    parser.add_argument("--genome_in", type=str, help="path to genome fasta", required=True)
    parser.add_argument("--ccre_in_bed", type=str, help="location of ccRE.bed.gz", required=False, default=None)
    parser.add_argument("--remove_temp_files", type=bool, required=False, default=False)
    args = parser.parse_args()

    if args.ccre_in_bed is not None:
        ccre_in_bed = Path(args.ccre_in_bed)
    else:
        ccre_in_bed = None

    main(
        full_peak_bed=Path(args.full_peak_bed),
        bed_file=Path(args.bed_file),
        bed_dir_int=Path(args.bed_dir_int),
        ccre_in_bed=ccre_in_bed,
        remove_temp_files=args.remove_temp_files,
        genome_in=args.genome_in
    )
