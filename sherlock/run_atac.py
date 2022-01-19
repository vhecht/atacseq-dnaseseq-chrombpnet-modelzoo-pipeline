import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac.tsv"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac_new.tsv"

oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/ATAC/"
bias_model="/scratch/groups/akundaje/anusri/chromatin_atlas/reference/bias.h5"

# choose the cet of accessions to run
encode_ids = [line.strip() for line in open("atac_files/cell_type.txt").readlines()]
#encode_ids = [line.strip() for line in open("tissue_type.txt").readlines()]
#encode_ids = [line.strip() for line in open("atac_files/primary_cell_accession.txt").readlines()]
#encode_ids = [line.strip() for line in open("atac_files/invitro_accession.tsv").readlines()]

done = []
undone = []

# only 50 GPU jobs allowed on sherlock so limit this array - an run in batches of 50
for encode_id in encode_ids[0:1]:
	if encode_id in done:
		continue
	if encode_id in undone:
		continue
	print(output_dir+"/"+encode_id)
	#command = "bash start_preprocessing.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir  + " " + bias_model
	#command = "bash start_interpretation.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modisco.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir
	command = "bash start_interpretation_counts.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	print(command)
	os.system(command)
