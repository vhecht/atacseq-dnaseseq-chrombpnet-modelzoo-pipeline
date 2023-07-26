import os
import shutil

#output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac.tsv"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac_new.tsv"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac_unreleased.tsv"


oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/ATAC/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/ATAC/"

# choose the cet of accessions to run
encode_ids = [line.strip() for line in open("../atac_files/cell_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/tissue_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/primary_cell_accession.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/invitro_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/immune_atals_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/atac_unreleased_accession.tsv").readlines()]



done = []
undone = []
#for encode_id in encode_ids:
for encode_id in ["ENCSR291GJU"]:
	if encode_id in done:
		continue
	if encode_id in undone:
		continue
	print(oak_dir+"/"+encode_id)


	#command = "bash start_gc_test_bed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	command = "bash start_gc_test_bed.sh " + encode_id + " " + oak_dir
	print(command)
	os.system(command)

	#command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_0" + " " + "chrombpnet_model_feb15"
	#print(command)
	#os.system(command)

	#command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_1" + " " + "chrombpnet_model_feb15_fold_1"
	#print(command)
	#os.system(command)

	#command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_2" + " " + "chrombpnet_model_feb15_fold_2"
	#print(command)
	#os.system(command)

	#command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_3" + " " + "chrombpnet_model_feb15_fold_3"
	#print(command)
	#os.system(command)

	#command = "bash start_prediction.sh " + encode_id + " " + oak_dir + " " + "fold_4" + " " + "chrombpnet_model_feb15_fold_4"
	#print(command)
	#os.system(command)

