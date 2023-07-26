import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"

#bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hepg2_dnase.h5"
#bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR283TME_bias_0.9.h5"
#bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR880CUB_bias_0.9.h5"
#bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR146KFX_bias_0.9.h5"
bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/HEPG2_DNASE_PE/fold_0/bias.h5"

#bias_model_1="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/HEPG2_DNASE_PE/fold_1/bias.h5"
#bias_model_2="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/HEPG2_DNASE_PE/fold_2/bias.h5"
#bias_model_3="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/HEPG2_DNASE_PE/fold_3/bias.h5"
#bias_model_4="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/HEPG2_DNASE_PE/fold_4/bias.h5"

#bias_model_1="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR283TME/fold_1/bias.h5"
#bias_model_2="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR283TME/fold_2/bias.h5"
#bias_model_3="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR283TME/fold_3/bias.h5"
#bias_model_4="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR283TME/fold_4/bias.h5"

bias_model_1="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR146KFX/fold_1/bias.h5"
bias_model_2="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR146KFX/fold_2/bias.h5"
bias_model_3="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR146KFX/fold_3/bias.h5"
bias_model_4="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR146KFX/fold_4/bias.h5"

#bias_model_1="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR880CUB/fold_1/bias.h5"
#bias_model_2="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR880CUB/fold_2/bias.h5"
#bias_model_3="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR880CUB/fold_3/bias.h5"
#bias_model_4="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR880CUB/fold_4/bias.h5"

oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"

#encode_ids = [line.strip() for line in open("dnase_files/cellline_dnase_accession.tsv").readlines()]
#encode_ids = [line.strip() for line in open("dnase_files/tissue_dnase_accession.txt").readlines()]
encode_ids = [line.strip() for line in open("dnase_files/invitro_all_accession.tsv").readlines()]
#encode_ids = [line.strip() for line in open("dnase_files/primary_cell_accession.tsv").readlines()]




#done = [line.strip() for line in open("all_passed.txt").readlines()]

for encode_id in encode_ids:
	#if encode_id not in done:
	#	continue
	#if encode_id in undone:
	#	continue
	print(output_dir+"/"+encode_id)

	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir  + " " + bias_model_1 + " " + "1"
	#print(command)
	#os.system(command)

	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir  + " " + bias_model_2 + " " + "2"
	#print(command)
	#os.system(command)

	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir  + " " + bias_model_3 + " " + "3"
	#print(command)
	#os.system(command)

	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir  + " " + bias_model_4 + " " + "4"
	#print(command)
	#os.system(command)

	command = "bash start_interpretation_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + oak_bw_dir
	print(command)
	os.system(command)

	#command = "bash start_preprocessing.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_peak_calling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + bias_model + " " + "0"
	#command = "bash start_interpretation.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_ccre_filling_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + oak_bw_dir
	#command = "bash start_modisco_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir + " " + oak_dir
	#command = "bash start_interpret_bigwig.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	#command = "bash start_prediction.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	#command = "bash start_modisco.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir + " " + oak_dir
	#print(command)
	#os.system(command)

