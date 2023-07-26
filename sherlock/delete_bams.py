import os
import pandas as pd
import json
import subprocess

oak_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC"
for name in os.listdir(oak_dir):
	bam_path = oak_dir + "/" + name + "/preprocessing/intermediates/sorted_"+name+".bam"
	bam_idx_path = oak_dir + "/" + name + "/preprocessing/intermediates/sorted_"+name+".bam.bai"
	print(bam_path)

	if not os.path.isfile(bam_path):
		continue

	command = "mkdir "+ oak_dir + "/" + name + "/preprocessing/sorted_bams/"
	os.system(command)
	command = "mv "+ bam_path + " " + oak_dir + "/" + name + "/preprocessing/sorted_bams/"
	os.system(command)
	command = "mv "+ bam_idx_path + " " + oak_dir + "/" + name + "/preprocessing/sorted_bams/"
	os.system(command)
	command = "rm " + oak_dir + "/" + name + "/preprocessing/intermediates/*.bam"
	os.system(command)
	command = "rm " + oak_dir + "/" + name + "/preprocessing/downloads/*.bam"
	os.system(command)


