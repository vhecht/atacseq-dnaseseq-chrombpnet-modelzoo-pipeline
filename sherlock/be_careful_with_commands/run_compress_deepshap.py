import os
import pandas as pd
import json
import subprocess
import argparse


def read_args():
	parser = argparse.ArgumentParser(description="Get SamStats")
	parser.add_argument('-n', '--name', required=True, type=str, help="encode_id")
	parser.add_argument('-m', '--model-name', required=True, type=str, help="model_name")
	parser.add_argument('-d', '--dir', required=True, type=str, help="model dir")
	args = parser.parse_args()
	return args

def main(name,model_name, dir_name):
	print(name)

	in_dir_t=dir_name+name+"/"+model_name+"/interpret/full_"+name+".counts_scores.h5"
	out_dir_t=dir_name+name+"/"+model_name+"/interpret/full_"+name+".counts_scores"
	if os.path.isfile(in_dir_t):
		if not os.path.isfile(out_dir_t+"_compressed.h5"):
			os.system("python compress_deepshap.py -i "+in_dir_t+" -o "+out_dir_t)

	in_dir_t=dir_name+name+"/"+model_name+"/interpret/full_"+name+".profile_scores.h5"
	out_dir_t=dir_name+name+"/"+model_name+"/interpret/full_"+name+".profile_scores"
	if os.path.isfile(in_dir_t):
		if not os.path.isfile(out_dir_t+"_compressed.h5"):
			os.system("python compress_deepshap.py -i "+in_dir_t+" -o "+out_dir_t)

			
if __name__=="__main__":
	args = read_args()
	main(args.name, args.model_name, args.dir)

