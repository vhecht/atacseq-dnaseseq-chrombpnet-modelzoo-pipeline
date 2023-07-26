import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
#metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_duke_dnase.tsv"

bias_model="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR000EKP/fold_0/bias.h5" 
bias_model_1="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR000EKP/fold_1/bias.h5" 
bias_model_2="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR000EKP/fold_2/bias.h5" 
bias_model_3="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR000EKP/fold_3/bias.h5" 
bias_model_4="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/ENCSR000EKP/fold_4/bias.h5" 


metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"

oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"
oak_bw_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/DNASE/"

#encode_ids = [line.strip() for line in open("dnase_files/cellline_duke_accession.txt").readlines()]
#encode_ids += [line.strip() for line in open("dnase_files/tissue_duke_accession.txt").readlines()]
#encode_ids += [line.strip() for line in open("dnase_files/primary_duke_accession.txt").readlines()]

#encode_ids = [line.strip() for line in open("dnase_files/large_mem_mixed_bams.txt").readlines()]
encode_ids = [line.strip() for line in open("dnase_files/mixed_bams.txt").readlines()]


print(len(encode_ids))
#done = ["ENCSR678ILN"]


#for encode_id in ["ENCSR000FEK"]:
#	if encode_id in done:
#		continue


#for encode_id in encode_ids:
for encode_id in ["ENCSR362JSZ"]:

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
	#command = "bash start_peak_calling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + bias_model + " 0"
	#command = "bash start_interpretation.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir 
	#command = "bash start_ccre_filling_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir + " " + oak_bw_dir
	#command = "bash start_modisco_compressed.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir + " " + oak_dir
	#command = "bash start_interpret_bigwig.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	#command = "bash start_prediction.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_bw_dir + " " +  oak_dir
	#command = "bash start_modisco.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir + " " + oak_dir
	print(command)
	os.system(command)
