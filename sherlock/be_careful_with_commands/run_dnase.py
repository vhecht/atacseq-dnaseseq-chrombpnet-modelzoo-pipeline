import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"

model_name = []

#encode_ids = ["ENCSR428ZCP"]
#encode_ids = [line.strip() for line in open("../dnase_files/tissue_dnase_accession.txt").readlines()]
#model_name = "chrombpnet_model_encsr880cub_bias"
#model_name = "chrombppnet_model_encsr880cub_bias_fold_1"


#encode_ids = [line.strip() for line in open("../dnase_files/primary_cell_accession.tsv").readlines()]
encode_ids = [line.strip() for line in open("../dnase_files/immuneatlas_new_files.txt").readlines()]
#model_name = "chrombppnet_model_encsr283tme_bias"
model_name = "chrombppnet_model_encsr283tme_bias_fold_4"

#encode_ids = [line.strip() for line in open("../dnase_files/cellline_dnase_accession.tsv").readlines()]
#model_name = "chrombpnet_model_feb15_fold_1"
#model_name = "chrombpnet_model"

#encode_ids = [line.strip() for line in open("../dnase_files/invitro_all_accession.tsv").readlines()]
#model_name = "chrombpnet_model_encsr146kfx_bias_fold_1"
#model_name = "chrombpnet_model_encsr146kfx_bias_fold_4"


for encode_id in encode_ids:

	print(output_dir+"/"+encode_id)

	#command = "bash start_samstats.sh " + encode_id + " " + model_name + " " + oak_dir
	#print(command)
	#os.system(command)

	#command = "bash start_ranked_del.sh " + encode_id + " " + model_name + " " + oak_dir
	#print(command)
	#os.system(command)

	#command = "bash start_bias_bigwig_del.sh " + encode_id + " " + model_name + " " + oak_bw_dir
	#print(command)
	#os.system(command)

	command = "bash start_compress_deepshap.sh " + encode_id + " " + model_name + " " + oak_dir
	print(command)
	os.system(command)
