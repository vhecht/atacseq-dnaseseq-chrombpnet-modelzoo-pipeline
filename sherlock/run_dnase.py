import os
import shutil

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/dnase_files/metadata_dnase_new.tsv"
oak_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"
oak_modisco_dir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/DNASE/"

encode_ids = [line.strip() for line in open("dnase_files/tissue_dnase_accession.txt").readlines()]
done = []
undone = []

#100-150 preprocessing done
#0-100 peak calling done
#0-100 gc-matching done

for encode_id in encode_ids[100:150]:
	if encode_id in done:
		continue
	if encode_id in undone:
		continue
	print(output_dir+"/"+encode_id)
	#command = "bash start_preprocessing.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	command = "bash start_peak_calling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_interpretation.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_dir
	#command = "bash start_modisco.sh " + encode_id + " " + output_dir + " " + metadata_tsv + " " + oak_modisco_dir
	print(command)
	os.system(command)
