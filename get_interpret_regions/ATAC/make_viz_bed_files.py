import argparse
import os
import numpy as np
import pandas as pd
import subprocess
from pandas.errors import EmptyDataError

odir = "/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
encids = os.listdir(odir)
errors = []
def main():

	for encid in encids:
	
		prep_commands=[]

		bed_dir_int=odir+encid+"/interpret_uploads/"
		bed_file=os.path.join(bed_dir_int,"100K.ranked.subsample.overlap.bed.gz")
		temp_file=os.path.join(bed_dir_int,"100K.ranked.merged.bed.gz")
		output_file_extra=os.path.join(bed_dir_int,"extra.regions.bed.gz")
		output_file_all=os.path.join(bed_dir_int,"selected.regions.bed.gz")
		output_file_merged=os.path.join(bed_dir_int,"selected.regions.merged.bed.gz")
		log_file=os.path.join(bed_dir_int,"selected_regions.log")
		full_peak_bed = odir + encid + "/preprocessing/downloads/peaks.bed.gz"
		
		if os.path.isfile(output_file_merged):
			continue
			
		print(encid)
		if os.path.isfile(bed_file):

			command = "bedtools sort -i "+bed_file+" | bedtools merge -i stdin | gzip > "+temp_file
			print(command)
			prep_commands.append(command)
			exit_code = os.system(command)
			
			if exit_code > 0:		
				prep_commands.append(exit_code)
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error in merging 100k"])
				continue
				

			command = "bedtools intersect -v -wa -a "+full_peak_bed+" -b "+temp_file+" | sort | uniq | gzip > "+output_file_extra
			print(command)
			prep_commands.append(command)
			exit_code = os.system(command)

			if exit_code > 0:		
				prep_commands.append(exit_code)
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error in bedtools intersect -v"])
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
				prep_commands.append(exit_code)
				log_lines = "\n".join(prep_commands)
				f = open(log_file, "w")
				f.write(log_lines)
				f.close()
				errors.append([encid, "error merging selected regions"])
				continue			

			command = "rm "+output_file_extra
			os.system(command)
			prep_commands.append(command)

			command = "rm "+temp_file
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
	df.to_csv("making_sel_regions_atac.tsv", sep="\t", header=False, index=False)
	
if __name__=="__main__":
        main()
