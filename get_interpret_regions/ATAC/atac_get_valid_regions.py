import argparse
import os
import numpy as np
import pandas as pd
import subprocess
from pandas.errors import EmptyDataError
import pyfaidx

odir = "/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
genome="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa"
#encids = os.listdir(odir)
#encids = ["ENCSR332HAD", "ENCSR241BNZ", "ENCSR561ZLY", "ENCSR631XIF", "ENCSR173YSO"]

errors = []

def get_seq(peaks_df, genome, width=2114):
    """
    Same as get_cts, but fetches sequence from a given genome.
    """
    vals = []
    peaks_used = []
    for i, r in peaks_df.iterrows():
        sequence = str(genome[r['chr']][(r['start']+r['summit'] - width//2):(r['start'] + r['summit'] + width//2)])
        if len(sequence)==2114:
        	peaks_used.append(True)
        else:
        	peaks_used.append(False)
    return np.array(peaks_used)

NARROWPEAK_SCHEMA = ["chr", "start", "end", "1", "2", "3", "4", "5", "6", "summit"]

def main():

	genome_fa = pyfaidx.Fasta(genome)
	encids = os.listdir(odir)
	records = []
	
	for encid in encids:
	
		prep_commands=[]
		
		bed_dir_int=odir+encid+"/interpret_uploads/"
		output_file_all=os.path.join(bed_dir_int,"selected_new.regions.bed.gz")
		output_file_all_valid=os.path.join(bed_dir_int,"selected_new.valid.regions.bed.gz")
		output_file_merged=os.path.join(bed_dir_int,"selected_new.regions.valid.merged.bed.gz")
		
		if os.path.isfile(output_file_all_valid): 
			continue
			
		if os.path.isfile(output_file_all):
			peaks_df = pd.read_csv(output_file_all, sep="\t", header=None, names=NARROWPEAK_SCHEMA)
			filterd = get_seq(peaks_df, genome_fa, width=2114)
			peaks_df[filterd].to_csv(output_file_all_valid, sep="\t", header=False, index=False, compression="gzip")
			print(sum(~filterd))
			print(peaks_df.shape)
			print(peaks_df[filterd].shape)
			records.append([encid, sum(~filterd), peaks_df.shape[0], peaks_df[filterd].shape[0]])
			
			command = "zcat "+output_file_all_valid+" |  awk -v FS=\'\\t\' -v OFS=\'\\t\'  \'{print $1,$2+$10-500,$2+$10+500,$4,$5,$6,$7,$8, $9, $10}\' |  awk  -v FS=\'\\t\' -v OFS=\'\\t\'  '$2<0 {$2=0} 1' | bedtools sort -i stdin |  bedtools merge -i stdin | gzip > "+output_file_merged
			print(command)
			os.system(command)
		
		records_df = pd.DataFrame(records)
		records_df.to_csv("filtered_regions_dnase_v2.tsv", sep='\t', header=False, index=False)
			
if __name__=="__main__":
        main()
		
			
		
		
		
