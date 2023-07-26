import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/ATAC_files/metadata_ATAC_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/ATAC/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/ATAC/"

model_name = []

encode_ids = [line.strip() for line in open("../atac_files/cell_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/tissue_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/primary_cell_accession.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/invitro_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/immune_atals_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/atac_unreleased_accession.tsv").readlines()]


#model_name="chrombpnet_model_feb15"
model_name="chrombpnet_model_feb15_fold_4"

print(len(encode_ids))
for encode_id in encode_ids:
	print(output_dir+"/"+encode_id)

	#command = "bash start_samstats.sh " + encode_id + " " + model_name + " " + oak_dir
	#print(command)
	#os.system(command)

	#command = "bash start_compress_deepshap.sh " + encode_id + " " + model_name + " " + oak_dir
	#print(command)
	#os.system(command)
