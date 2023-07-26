import argparse
import os
import numpy as np
import pandas as pd

def parse_args():
	parser = argparse.ArgumentParser(description="Find regions to fill")
	parser.add_argument("-i", "--input_dir", type=str, required=True, help="")
	parser.add_argument("-if", "--input_file", type=str, required=True, help="")
	parser.add_argument("-e", "--experiment", type=str, required=True, help="")
	parser.add_argument("-o", "--output_file", type=str, required=True, help="")
	parser.add_argument("-t", "--type", type=str, required=True, help="")
	args = parser.parse_args()
	return args

def main(args):

	bed_files=None
	filer =  args.input_file
	bed_file = os.path.join(args.input_dir,os.path.join(filer,"interpret/full_"+args.experiment+".interpreted_regions_"+args.type+".bed"))
	if os.path.isfile(bed_file):
		bed_files = bed_file
	else:
		bed_file = os.path.join(args.input_dir,os.path.join(filer,"interpret/full_"+args.experiment+".interpreted_regions.bed"))
		if os.path.isfile(bed_file):
			bed_files = bed_file

	assert(bed_files!=None)

	command = "bedtools sort -i "+bed_file+" | bedtools merge -i stdin > "+args.output_file+".merged."+args.type+".bed"
	print(command)
	os.system(command)

	full_peak_bed = args.input_dir + "/preprocessing/downloads/peaks.bed.gz"

	if os.path.isfile(full_peak_bed):
		peaks = pd.read_csv(full_peak_bed,sep="\t", header=None)
	else:
		assert(os.path.isfile(full_peak_bed) == True)

	full_peak_bed=args.output_file+".fdr.th.temp."+args.type+".bed"

	fdr_1 = peaks[peaks[8]>2]
	fdr_1.to_csv(full_peak_bed, header=False, index=False, sep="\t")


	command = "bedtools intersect -v -wa -a "+full_peak_bed+" -b "+args.output_file+".merged."+args.type+".bed | sort | uniq > "+args.output_file+".final.temp."+args.type+".bed"
	print(command)
	os.system(command)

	command = "cat "+full_peak_bed+" |  awk -v FS=\'\\t\' -v OFS=\'\\t\'  \'{print $1,$2+$10-500,$2+$10+500,$4,$5,$6,$7,$8, $9, $10}\' |  bedtools sort -i stdin |  bedtools merge -i stdin > "+args.output_file+".merged1."+args.type+".bed"
	print(command)
	os.system(command)

	url="http://users.wenglab.org/moorej3/Registry-cCREs-WG/V4-Files/"

	celld = pd.read_csv("ccres_cell_type_specfic.csv",sep=",")
	print(celld.head())
	val = celld[celld["Experiment"]==args.experiment]["cCRE File"].values
	if len(val) == 1:
		print("ccre file found")
		command = "wget "+url+val[0]+" "+"-O "+args.output_file+".ccre.bed.gz"
		print(command)
		os.system(command)

		command = "bedtools intersect -v -wa -a "+args.output_file+".ccre.bed.gz"+" -b "+args.output_file+".merged1."+args.type+".bed | sort | uniq | grep -v \"Low-DNase\" > "+args.output_file+".final.temp2."+args.type+".bed"
		print(command)
		os.system(command)
		

		command = "rm "+args.output_file+".ccre.bed.gz"
		print(command)
		os.system(command)

		# check if file is non empty
		bed_ccre = pd.read_csv(args.output_file+".final.temp2."+args.type+".bed",sep="\t",header=None)
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

			if os.stat(args.output_file+".final.temp."+args.type+".bed").st_size > 0:
				old_bed = pd.read_csv(args.output_file+".final.temp."+args.type+".bed",sep="\t",header=None)
				final_bed = pd.concat([bed_ccre_new, old_bed])
			else:
				final_bed = bed_ccre_new
			final_bed.to_csv(args.output_file+".final."+args.type+".bed", header=False, index=False, sep="\t")
		else:
		
			command = "mv "+args.output_file+".final.temp."+args.type+".bed "+args.output_file+".final."+args.type+".bed"
			print(command)
			os.system(command)

	else:
		print("no ccre file")
		command = "mv "+args.output_file+".final.temp."+args.type+".bed "+args.output_file+".final."+args.type+".bed"
		print(command)
		os.system(command)

if __name__=="__main__":
	args = parse_args()
	main(args)
