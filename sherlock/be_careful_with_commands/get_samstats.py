import os
import pandas as pd
import json
import subprocess
import argparse


def read_args():
	parser = argparse.ArgumentParser(description="Get SamStats")
	parser.add_argument('-n', '--name', required=True, type=str, help="encode_id")
	parser.add_argument('-m', '--model-name', required=True, type=str, help="model_name")
	args = parser.parse_args()
	return args

oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC"

def main(name,model_name):
	print(name)
	
	bam_path = oak_dir + "/" + name + "/preprocessing/intermediates/sorted_"+name+".bam"

	if not os.path.isfile(bam_path):
		bam_path = oak_dir + "/" + name + "/preprocessing/sorted_bams/sorted_"+name+".bam"
		if not os.path.isfile(bam_path):
			return
		else:
			path= oak_dir + "/" + name + "/preprocessing/sorted_bams/sorted_"+name
			out_path=oak_dir + "/" + name + "/preprocessing/sorted_bams/"

	else:
		path= oak_dir + "/" + name + "/preprocessing/intermediates/sorted_"+name

		out_path=oak_dir + "/" + name + "/preprocessing/sorted_bams/"
		isExist = os.path.exists(out_path)
		if not isExist:
			# Create a new directory because it does not exist
   			os.makedirs(out_path)


	out_file = "{}.samstats.qc".format(out_path+"sorted_"+name)

	if os.path.isfile(out_file):
		data = open(out_file).readlines()
		if int(data[0].split("+")[0].strip()) > 0:
			print(int(data[0].split("+")[0].strip()))
			return

	command = "samtools sort -n {}.bam -T {}.bam.tmpst.tmp -@40 -O sam | SAMstats --sorted_sam_file - --outf {}.samstats.qc".format(path,path,out_path+"sorted_"+name)


	print(command)
	error_no = os.system(command)
	print("error code", error_no)
	if error_no == 0:
		oak_dir_t="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"+name+"/"+model_name+"/chrombpnet_wo_bias.h5"
		print(oak_dir_t)
		if os.path.isfile(oak_dir_t):
			print("dir found")
			command = "rm  "+bam_path
			print(command)
			os.system(command)

			command = "rm  "+bam_path+".bai"
			print(command)
			os.system(command)

			command = "rm  "+ oak_dir + "/" + name + "/preprocessing/intermediates/*.bam"
			print(command)
			os.system(command)

			command = "rm  "+ oak_dir + "/" + name + "/preprocessing/intermediates/*.bedGraph"
			print(command)
			os.system(command)


if __name__=="__main__":
	args = read_args()
	main(args.name, args.model_name)

