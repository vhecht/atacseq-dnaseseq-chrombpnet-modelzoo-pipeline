import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac.tsv"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac_new.tsv"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac_unreleased.tsv"


oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/ATAC/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/ATAC/"
#bias_model="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/k562_atac_bias_new.h5"

bias_model_1="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/atac_bias_models/fold_1/bias.h5"
bias_model_2="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/atac_bias_models/fold_2/bias.h5"
bias_model_3="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/atac_bias_models/fold_3/bias.h5"
bias_model_4="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/atac_bias_models/fold_4/bias.h5"

# choose the cet of accessions to run
encode_ids = [line.strip() for line in open("atac_files/cell_type.txt").readlines()]
encode_ids += [line.strip() for line in open("atac_files/tissue_type.txt").readlines()]
encode_ids += [line.strip() for line in open("atac_files/primary_cell_accession.txt").readlines()]
encode_ids += [line.strip() for line in open("atac_files/invitro_accession.tsv").readlines()]
#encode_ids += [line.strip() for line in open("atac_files/immune_atals_accession.tsv").readlines()]

encode_ids += [line.strip() for line in open("atac_files/atac_unreleased_accession.tsv").readlines()]
#encode_ids = [line.strip() for line in open("atac_files/undone_jan27_files.txt").readlines()]
#encode_ids = [line.strip() for line in open("atac_files/feb_1_2023_pending.txt").readlines()]
#encode_ids = [line.strip() for line in open("out_of_memmory.txt").readlines()]


done = []
undone = []

#print(len(encode_ids))
# only 50 GPU jobs allowed on sherlock so limit this array - an run in batches of 50
for encode_id in encode_ids:
	if encode_id in done:
		continue
	if encode_id in undone:
		continue
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

	#command = "bash start_interpretation_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + oak_bw_dir
	#print(command)
	#os.system(command)

	#command = "bash start_preprocessing.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_interpretation.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_interpretation_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + oak_bw_dir
	#command = "bash start_interpret_bigwig.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	command = "bash start_prediction.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	#command = "bash start_modisco.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir + " " + oak_dir
	#command = "bash start_interpretation_counts.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir

	#print(command)
	os.system(command)
