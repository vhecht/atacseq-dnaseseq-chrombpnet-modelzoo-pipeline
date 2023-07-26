import os
import shutil


oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"

# choose the cet of accessions to run
#encode_ids = [line.strip() for line in open("../all_passed.txt").readlines()]
#encode_ids = [line.strip() for line in open("../combine_deepshaps/primary_passed.txt").readlines()]
encode_ids = [line.strip() for line in open("../combine_deepshaps/tissue_passed.txt").readlines()]


done = []
undone = []
for encode_id in encode_ids[200:]:
	if encode_id in done:
		continue
	if encode_id in undone:
		continue
	print(oak_dir+"/"+encode_id)

	#command = "bash start_gc_test_bed.sh " + encode_id + " " + oak_dir
	#print(command)
	#os.system(command)

	command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_0" + " " + "chrombpnet_model_encsr880cub_bias"
	print(command)
	os.system(command)

	command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_1" + " " + "chrombppnet_model_encsr880cub_bias_fold_1"
	print(command)
	os.system(command)

	command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_2" + " " + "chrombppnet_model_encsr880cub_bias_fold_2"
	print(command)
	os.system(command)

	command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_3" + " " + "chrombppnet_model_encsr880cub_bias_fold_3"
	print(command)
	os.system(command)

	command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_4" + " " + "chrombppnet_model_encsr880cub_bias_fold_4"
	print(command)
	os.system(command)

