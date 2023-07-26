import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"

#encode_ids = [line.strip() for line in open("tissue_type.txt").readlines()]
#encode_ids = [line.strip() for line in open("passed_bias_model_qc.txt").readlines()]
#encode_ids = [line.strip() for line in open("failed_bias_qc.txt").readlines()]
encode_ids = [line.strip() for line in open("passed_bias_model_qc_round_2.txt").readlines()]
#encode_ids = [line.strip() for line in open("failed_bias_round_2.txt").readlines()]
#ignore = [line.strip() for line in open("ignore_list.txt").readlines()]
#ignore = [line.strip() for line in open("html_running_1.txt").readlines()]
#ignore = [line.strip() for line in open("chrombpnet_running.txt").readlines()]
ignore = []
#print(ignore)



for encode_id in encode_ids:

	if encode_id in ignore:
		continue

	#print(output_dir+"/"+encode_id)
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0"
	#print(command)
	#os.system(command)


	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "1"
	#print(command)
	#os.system(command)

	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "2"
	#print(command)
	#os.system(command)

	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "3"
	#print(command)
	#os.system(command)

	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "4"
	#print(command)
	#os.system(command)

	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.4" + " " + "0"
	command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0"
	print(command)
	os.system(command)


	command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "1"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "1"
	#print(command)
	#os.system(command)


	command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "2"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "2"
	#print(command)
	#os.system(command)


	command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "3"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "3"
	#print(command)
	#os.system(command)

	command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "4"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "4"
	#print(command)
	#os.system(command)








