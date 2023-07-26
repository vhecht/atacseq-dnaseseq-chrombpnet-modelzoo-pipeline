import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"


#encode_ids = [line.strip() for line in open("stage1_bias_models_thresh_0.8.txt").readlines()]
#encode_ids = [line.strip() for line in open("stage2_bias_models_thresh_0.6.txt").readlines()]
encode_ids = [line.strip() for line in open("stage3_bias_models_thresh_0.4.txt").readlines()]
#encode_ids = [line.strip() for line in open("recheck_set_and_some_extras_0.6.txt").readlines()]
ignore = []

#print(ignore)

#dict_models = {"stage1_bias_models_thresh_0.8.txt":"chrombpnet_model_feb15_fold_0",
#        "stage2_bias_models_thresh_0.6.txt":"chrombpnet_model_feb20_fold_0",
#        "stage3_bias_models_thresh_0.4.txt":"chrombpnet_model_feb22_fold_0",
#        "recheck_set_and_some_extras_0.6.txt":"chrombpnet_model_feb20_fold_0",}

#modelname="chrombpnet_model_feb15_fold_0"
#modelname="chrombpnet_model_feb20_fold_0"
modelname="chrombpnet_model_feb22_fold_0"

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

	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "0"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0"
	#print(command)
	#os.system(command)

	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "1"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "1"
	#print(command)
	#os.system(command)


	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "2"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "2"
	#print(command)
	#os.system(command)


	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "3"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "3"
	#print(command)
	#os.system(command)

	#command = "bash start_bias_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "0.6" + " " + "4"
	#command = "bash start_chrombpnet_modelling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + "4"
	#print(command)
	#os.system(command)


	command = "bash start_interpretation_compressed.sh " + encode_id + " " + oak_dir + " " + oak_bw_dir + " " + modelname
	print(command)
	os.system(command)

	command = "bash start_interpretation_compressed.sh " + encode_id + " " + oak_dir + " " + oak_bw_dir + " " + modelname.replace("fold_0", "fold_1")
	print(command)
	os.system(command)

	command = "bash start_interpretation_compressed.sh " + encode_id + " " + oak_dir + " " + oak_bw_dir + " " + modelname.replace("fold_0", "fold_2")
	print(command)
	os.system(command)

	command = "bash start_interpretation_compressed.sh " + encode_id + " " + oak_dir + " " + oak_bw_dir + " " + modelname.replace("fold_0", "fold_3")
	print(command)
	os.system(command)


	command = "bash start_interpretation_compressed.sh " + encode_id + " " + oak_dir + " " + oak_bw_dir + " " + modelname.replace("fold_0", "fold_4")
	print(command)
	os.system(command)

