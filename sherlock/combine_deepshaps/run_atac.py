import os

oakd="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"

model=["chrombpnet_model_feb15", "chrombpnet_model_feb15_fold_1", "chrombpnet_model_feb15_fold_2", "chrombpnet_model_feb15_fold_3", "chrombpnet_model_feb15_fold_4"]

#data = open("../atac_files/primary_cell_accession.txt").readlines()
#data = [line.strip() for line in  data]
encode_ids = [line.strip() for line in open("../atac_files/cell_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/tissue_type.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/primary_cell_accession.txt").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/invitro_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/immune_atals_accession.tsv").readlines()]
encode_ids += [line.strip() for line in open("../atac_files/atac_unreleased_accession.tsv").readlines()]

data = encode_ids

running = [line.strip() for line in open("../run.temp.txt")]
running += [line.strip() for line in open("../pending.temp.txt")]

for encode_id in data:
	#if encode_id in running:
	#	continue

	#command = "bash start_combine_deepshap.sh "+encode_id+" "+model[0]+" "+model[1]+" "+model[2]+" "+model[3]+" "+model[4]+" "+oakd+" ATAC"
	#os.system(command)
	#print(command)

	command = "bash start_modisco_lite.sh "+encode_id+" ATAC"
	os.system(command)
	print(command)

