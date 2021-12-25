import os

output_dir="/scratch/groups/akundaje/anusri/chromatin_atlas/ATAC_chrombpnet"
metadata_tsv="/home/users/anusri/chromatin-atlas-anvil/sherlock/metadata_atac.tsv"

#encode_ids = [line.strip() for line in open("query_atac.txt").readlines()]
#done = ["ENCSR991PBP", "ENCSR476VJY"]
#encode_ids = ["ENCSR991PBP", "ENCSR476VJY"]
done = []
encode_ids = ["ENCSR483RKN", "ENCSR637XSC", "ENCSR291GJU", "ENCSR200OML"]
for encode_id in encode_ids:
	if encode_id in done:
		continue
	command = "bash start_preprocessing.sh " + encode_id + " " + output_dir + " " + metadata_tsv
	#command = "bash start_gc_matching.sh " + encode_id + " " + output_dir + " " + metadata_tsv
	#command = "bash start_modeling.sh " + encode_id + " " + output_dir + " " + metadata_tsv
	print(command)
	os.system(command)
