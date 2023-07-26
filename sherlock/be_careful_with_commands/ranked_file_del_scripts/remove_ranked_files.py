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

oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE"

def main(name,model_name):
	print(name)
	oak_dir_t="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+name+"/"+model_name+"/interpret/ranked_"+name+".profile_scores.h5"
	print(oak_dir_t)
	if os.path.isfile(oak_dir_t):
		os.remove(oak_dir_t)

	oak_dir_t="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+name+"/"+model_name+"/interpret/ranked_"+name+".interpreted_regions_profile.bed"
	print(oak_dir_t)
	if os.path.isfile(oak_dir_t):
		os.remove(oak_dir_t)

	oak_dir_t="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+name+"/"+model_name+"/interpret/ranked_"+name+".interpreted_regions.bed"
	print(oak_dir_t)
	if os.path.isfile(oak_dir_t):
		os.remove(oak_dir_t)
			
if __name__=="__main__":
	args = read_args()
	main(args.name, args.model_name)

