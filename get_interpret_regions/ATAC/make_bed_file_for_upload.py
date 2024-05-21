import pandas as pd
import os
import deepdish as dd

odir = "/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"
encids = os.listdir(odir)
results = []
fixed = []

errors = []
for encid in encids[0:3]:
	
	print(encid)
	top_100k_modisco="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"+encid+"/preprocessing/downloads/100K.ranked.subsample.overlap.bed"
	if os.path.isfile(top_100k_modisco):
		peak_top = pd.read_csv(top_100k_modisco, sep='\t', header=None)
		if peak_top.shape[0] > 100000:
			errors.append([encid, "top_100K_bed_more_regs", top_100k_modisco, peak_top.shape[0]])
			continue

		if peak_top.shape[0] < 100000:
			peaks="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"+encid+"/preprocessing/downloads/peaks.bed.gz"
			peaks_all = pd.read_csv(peaks, sep='\t', header=None)
			if peak_top.shape[0] != peaks_all.shape[0]:
				errors.append([encid, "error_in_top_100K", top_100k_modisco, peak_top.shape[0], peaks_all.shape[0]])
				continue			
				
		bed_dir_int="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"+encid+"/interpret_uploads/"
		os.makedirs(bed_dir_int, exist_ok=True)
		
		peak_top.to_csv(bed_dir_int+"100K.ranked.subsample.overlap.bed.gz", sep="\t", header=False, index=False, compression="gzip")
	else:
		errors.append([encid, "top_100K_modisco_not_found", top_100k_modisco])
	
df = pd.DataFrame(errors)
df.to_csv("modisco_input_bed_file_making.tsv", sep="\t", header=None, index=False)