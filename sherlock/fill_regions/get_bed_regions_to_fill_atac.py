import argparse
import os
import numpy as np

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

	command = "bedtools intersect -v -wa -a "+full_peak_bed+" -b "+args.output_file+".merged."+args.type+".bed | sort | uniq > "+args.output_file+".final."+args.type+".bed"
	print(command)
	os.system(command)


if __name__=="__main__":
	args = parse_args()
	main(args)
