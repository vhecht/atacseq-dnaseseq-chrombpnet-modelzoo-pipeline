import argparse
import os
import numpy as np
import pandas as pd
import subprocess
from pandas.errors import EmptyDataError

odir = "/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
encids = os.listdir(odir)
encids=["ENCSR332HAD", "ENCSR241BNZ", "ENCSR561ZLY", "ENCSR631XIF", "ENCSR173YSO"]

def get_ccre_regions(experiment, peaks_to_fill, final_regions,  fdr_merged_bed, prep_commands, errors, bed_dir_int, no_ccres_list, log_file):
	url="http://users.wenglab.org/moorej3/Registry-cCREs-WG/V4-Files/"
	ccre_temp_file_name=os.path.join(bed_dir_int,"cre.bed.gz")
	ccre_regions_preformatted=os.path.join(bed_dir_int,"cre.reformat.bed")
	
	celld = pd.read_csv("ccres_cell_type_specfic.csv",sep=",")
	val = celld[celld["Experiment"]==experiment]["cCRE File"].values
	if len(val) == 1:
		command = "wget "+url+val[0]+" "+"-O "+ccre_temp_file_name
		print(command)
		prep_commands.append(command)
		exit_code = os.system(command)
		if exit_code > 0:		
			prep_commands.append(str(exit_code))
			log_lines = "\n".join(prep_commands)
			f = open(log_file, "w")
			f.write(log_lines)
			f.close()
			errors.append([experiment, "error in wget"])
			return False, no_ccres_list, prep_commands, errors

		command = "bedtools intersect -v -wa -a "+ccre_temp_file_name+" -b "+fdr_merged_bed+" | sort | uniq | grep -v \"Low-DNase\" > "+ccre_regions_preformatted
		print(command)
		exit_code = os.system(command)
		prep_commands.append(command)
		if exit_code > 0:		
			prep_commands.append(str(exit_code))
			log_lines = "\n".join(prep_commands)
			f = open(log_file, "w")
			f.write(log_lines)
			f.close()
			errors.append([experiment, "error in bedtools intersect -v ccre"])
			return False, no_ccres_list, prep_commands, errors

		command = "rm "+ccre_temp_file_name
		os.system(command)
		prep_commands.append(command)

		# check if file is non empty
		if os.stat(ccre_regions_preformatted).st_size > 0:
			bed_ccre = pd.read_csv(ccre_regions_preformatted,sep="\t",header=None)
			print(bed_ccre.shape[0])
			if bed_ccre.shape[0] >= 1:
				bed_ccre_new=pd.DataFrame()
				bed_ccre_new[0] = bed_ccre[0]
				bed_ccre_new[1] = bed_ccre[1]
				bed_ccre_new[2] = bed_ccre[2]
				bed_ccre_new[3] = "."
				bed_ccre_new[4] = "."
				bed_ccre_new[5] = "."
				bed_ccre_new[6] = "."
				bed_ccre_new[7] = "."
				bed_ccre_new[8] = "."
				bed_ccre_new[9] = ((bed_ccre[1]+bed_ccre[2])//2)-bed_ccre[1]

				if os.stat(peaks_to_fill).st_size > 0:
						command = "combine in python "+peaks_to_fill+" "+ccre_regions_preformatted
						prep_commands.append(command)
						old_bed = pd.read_csv(peaks_to_fill,sep="\t",header=None)
						print(old_bed.shape)
						final_bed = pd.concat([bed_ccre_new, old_bed])
				else:
						command = "empty "+peaks_to_fill+" use only"+ccre_regions_preformatted
						prep_commands.append(command)
						final_bed = bed_ccre_new
				final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')

				command = "rm "+ccre_regions_preformatted
				os.system(command)
				prep_commands.append(command)

				return True, no_ccres_list, prep_commands, errors
		else:
			if os.stat(peaks_to_fill).st_size > 0:
				command = "empty "+ccre_regions_preformatted+" use only"+peaks_to_fill
				prep_commands.append(command)
				old_bed = pd.read_csv(peaks_to_fill, sep="\t", header=None)
				final_bed = old_bed
			else:
				command = "both empty "+ccre_regions_preformatted+" and"+peaks_to_fill
				prep_commands.append(command)
				final_bed = pd.DataFrame()
			final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')
			
			command = "rm "+ccre_regions_preformatted
			os.system(command)
			prep_commands.append(command)

			return True, no_ccres_list, prep_commands, errors
	else:
		print("no ccre file")

		no_ccres_list.append(experiment)
		command = "no html for "+ccre_regions_preformatted+" use only"+peaks_to_fill
		prep_commands.append(command)
		#command = "mv "+peaks_to_fill+" "+final_regions
		if os.stat(peaks_to_fill).st_size > 0:
			final_bed = pd.read_csv(peaks_to_fill, sep="\t", header=None)
			
			final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')
		else:
			command = "both empty "+ccre_regions_preformatted+" and"+peaks_to_fill
			prep_commands.append(command)
			final_bed = pd.DataFrame()
			final_bed.to_csv(final_regions, header=False, index=False, sep="\t", compression='gzip')
		return True, no_ccres_list, prep_commands, errors
		
def main():

	errors = []
	no_ccres_list = []
	num_done = 0
	#encids=["ENCSR689FYA"]
	for encid in encids:
		
		prep_commands=[]

		bed_dir_int=odir+encid+"/interpret_uploads/"
		bed_file=os.path.join(bed_dir_int,"100K.ranked.subsample.overlap.bed.gz")
		temp_file=os.path.join(bed_dir_int,"100K.ranked.merged.bed.gz")
		output_file_extra=os.path.join(bed_dir_int,"extra_new.regions.bed.gz")
		output_file_extra_temp=os.path.join(bed_dir_int,"extra.temp.regions.bed")

		output_file_all=os.path.join(bed_dir_int,"selected_new.regions.bed.gz")
		output_file_merged=os.path.join(bed_dir_int,"selected_new.regions.merged.bed.gz")
		log_file=os.path.join(bed_dir_int,"selected_new_regions.log")
		
		
		temp_fdr=os.path.join(bed_dir_int,"fdr.cutoff.peaks.bed.gz")
		temp_file_2=os.path.join(bed_dir_int,"fdr.cutoff.peaks.merged.bed")
		temp_peaks_filled=os.path.join(bed_dir_int,"fdr.filled.peaks.bed.gz")
		full_peak_bed = odir + encid + "/preprocessing/downloads/peaks.bed.gz"
		
		if os.path.isfile(output_file_merged):
			num_done+=1
			print(num_done)
			continue
			
		print(encid)
		if os.path.isfile(bed_file):

			command = "bedtools sort -i "+bed_file+" | bedtools merge -i stdin | gzip > "+temp_file
			print(command)
			prep_commands.append(command)
			exit_code = os.system(command)
			
			if exit_code > 0:		
				prep_commands.append(str(exit_code))
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error in merging 100k"])
				continue
				
			if os.path.isfile(full_peak_bed):
				 peaks = pd.read_csv(full_peak_bed,sep="\t", header=None)
			else:
				continue
			
			# temp file fdr thresholded
			print(peaks.shape[0])
			fdr_1 = peaks[peaks[8]>2]
			print(fdr_1.shape[0])
			prep_commands.append("filter peaks based on FDR, 8th column > 2")

			fdr_1.to_csv(temp_fdr, header=False, index=False, sep="\t")
			
			## get peak regions to fill regions
			## check how many of these files will throw an error
			command = "bedtools intersect -v -wa -a "+temp_fdr+" -b "+temp_file+" | sort | uniq > "+output_file_extra_temp
			print(command)
			prep_commands.append(command)
			exit_code = os.system(command)		
			if exit_code > 0:		
				prep_commands.append(str(exit_code))
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error in bedtools intersect -v"])
				continue

			try:
				df1 = pd.read_csv(output_file_extra_temp, sep="\t", header=None)
				df2 = pd.read_csv(bed_file, sep="\t", header=None)
				df3 = pd.concat([df1, df2])
				
			except:
				df2 = pd.read_csv(bed_file, sep="\t", header=None)
				df3 = df2
				
			#print(df3.head())
			df3[2] = df3[1] +  df3[9] + 500
			df3[1] = df3[1] +  df3[9] - 500
			df3[1] = df3[1].clip(0)
			#(df3.head())
			df3.to_csv(temp_peaks_filled, sep="\t", header=False, index=False)
			
			if df3.shape[0] < fdr_1.shape[0]:
				command = "zcat "+temp_peaks_filled+" | bedtools sort -i stdin |  bedtools merge -i stdin > "+temp_file_2
			else:
				command = "zcat "+temp_fdr+" |  awk -v FS=\'\\t\' -v OFS=\'\\t\'  \'{print $1,$2+$10-500,$2+$10+500,$4,$5,$6,$7,$8, $9, $10}\' |  awk  -v FS=\'\\t\' -v OFS=\'\\t\'  '$2<0 {$2=0} 1' | bedtools sort -i stdin |  bedtools merge -i stdin > "+temp_file_2
			
			prep_commands.append(command)
			exit_code = os.system(command)
			if exit_code > 0:		
				prep_commands.append(str(exit_code))
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error in merging peaks filtered by fdr"])
				continue			

			## get ccre regions to fill
			final_regions=output_file_extra
			flag, no_ccres_list, prep_commands, errors = get_ccre_regions(encid, output_file_extra_temp, final_regions, temp_file_2, prep_commands, errors, bed_dir_int, no_ccres_list, log_file)
			if not flag:
				continue
				
			try:
				extras = pd.read_csv(output_file_extra, sep="\t", header=None)
				bed_1 =  pd.read_csv(bed_file, sep="\t", header=None)
				combine = pd.concat([bed_1, extras])
				combine.to_csv(output_file_all, sep="\t", header=False, index=False, compression="gzip")
				command = 'concat in python '+output_file_extra+' '+bed_file+' to get '+output_file_all
				prep_commands.append(command)
			except EmptyDataError:
				command = "cp "+bed_file+" "+output_file_all
				os.system(command)
				prep_commands.append(command)

			command = "bedtools sort -i "+output_file_all+"| bedtools merge -i stdin | gzip > "+output_file_merged
			exit_code = os.system(command)
			prep_commands.append(command)

			if exit_code > 0:		
				prep_commands.append(str(exit_code))
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error merging selected regions"])
				continue			

			#command = "rm "+output_file_extra
			#os.system(command)
			#prep_commands.append(command)

			num_done+=1
			print(num_done)
			
			command = "rm "+temp_file
			os.system(command)
			prep_commands.append(command)
			
			command = "rm "+temp_file_2
			os.system(command)
			prep_commands.append(command)
			
			command = "rm "+output_file_extra_temp
			os.system(command)
			prep_commands.append(command)
			
			command = "rm "+temp_fdr
			os.system(command)
			prep_commands.append(command)
			
			command = "rm "+temp_peaks_filled
			os.system(command)
			prep_commands.append(command)
			
			output_v = subprocess.check_output("bedtools --version", shell=True)
			prep_commands.append(str(output_v))
		
			log_lines = "\n".join(prep_commands)

			f = open(log_file, "w")
			f.write(log_lines)
			f.close()
		else:
			errors.append([encid, "100K regions not found"])

	df = pd.DataFrame(errors)
	df.to_csv("making_sel_regions_dnase_new_v2.tsv", sep="\t", header=False, index=False)
	
	df = pd.DataFrame(no_ccres_list)
	df.to_csv("no_ccre_file_found_new_v2.tsv", sep="\t", header=False, index=False)

if __name__=="__main__":
        main()
