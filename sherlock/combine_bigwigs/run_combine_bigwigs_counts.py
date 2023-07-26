import argparse
import os
import pandas as pd
import json

parser = argparse.ArgumentParser()
parser.add_argument('--encid',type=str,required=True)
args = parser.parse_args()

encid=args.encid

model1="chrombpnet_model_feb15"

odir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/full_deepshaps/bigwigs/ATAC"
n_odir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/full_deepshaps/ATAC"

old_odir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC"
old_bdir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/bigwigs/ATAC"


num_models = []
files_used = {"fold_0":[], "fold_1":[], "fold_2":[] ,"fold_3":[], "fold_4":[]}

filen=odir+"/"+encid+"/"+model1+"/"+encid+".counts_v2.bigwig"
if os.path.exists(filen):
	num_models.append(filen)
	
	files_used['fold_0'].append(filen)
	
	interf=old_odir+"/"+encid+"/"+model1+"/interpret/full_"+encid+".counts_scores_compressed.h5"
	if os.path.exists(interf):
		files_used['fold_0'].append(interf)
		
	interf=n_odir+"/"+encid+"/"+model1+"/full_"+encid+".counts_scores_compressed_v2.h5"
	if os.path.exists(interf):
		files_used['fold_0'].append(interf)
		
	interf=old_odir+"/"+encid+"/"+model1+"/full_"+encid+".interpreted_regions_counts_v2.bed"
	if os.path.exists(interf):
		files_used['fold_0'].append(interf)
		files_used['selected regions bed'] = interf
else:
	interf=old_odir+"/"+encid+"/"+model1+"/interpret/full_"+encid+".interpreted_regions_counts.bed"
	if os.path.exists(interf):
		numl = len(open(interf).readlines())
		peaksn = old_odir+"/"+encid+"/preprocessing/downloads/peaks.bed.gz"
		df = pd.read_csv(peaksn, sep="\t",header=None)
		if abs(df.shape[0] - numl) < 10000:
			filep = old_bdir+"/"+encid+"/"+model1+"/full_"+encid+".counts.bigwig"
			if os.path.exists(filep):
				num_models.append(filep)
				files_used['fold_0'].append(filep)
			elif os.path.exists(old_bdir+"/"+encid+"/"+"/full_"+encid+".counts.bigwig"):
				num_models.append(old_bdir+"/"+encid+"/"+"/full_"+encid+".counts.bigwig")
				files_used['fold_0'].append(old_bdir+"/"+encid+"/"+"/full_"+encid+".counts.bigwig")
			elif os.path.exists(old_bdir+"/"+encid+"/"+"/test_"+encid+".counts.bigwig"):
				num_models.append(old_bdir+"/"+encid+"/"+"/test_"+encid+".counts.bigwig")
				files_used['fold_0'].append(old_bdir+"/"+encid+"/"+"/test_"+encid+".counts.bigwig")
			else:
				print(filep)
				
			
			if len(num_models) == 1:
				files_used['fold_0'].append(interf)
				interf=old_odir+"/"+encid+"/"+model1+"/interpret/full_"+encid+".counts_scores_compressed.h5"
				if os.path.exists(interf):
					files_used['fold_0'].append(interf)
				
	else:
		interf=old_odir+"/"+encid+"/"+model1+"/interpret/full_"+encid+".interpreted_regions.bed"
		if os.path.exists(interf):
			numl = len(open(interf).readlines())
			peaksn = old_odir+"/"+encid+"/preprocessing/downloads/peaks.bed.gz"
			df = pd.read_csv(peaksn, sep="\t",header=None)
			if abs(df.shape[0] - numl)<10000:
				filep = old_bdir+"/"+encid+"/"+model1+"/full_"+encid+".counts.bigwig"
				if os.path.exists(filep):
					num_models.append(filep)
				elif os.path.exists(old_bdir+"/"+encid+"/"+"/full_"+encid+".counts.bigwig"):
					num_models.append(old_bdir+"/"+encid+"/"+"/full_"+encid+".counts.bigwig")
				else:
					print(filep)
					
				if len(num_models) == 1:
					files_used['fold_0'].append(interf)
					interf=old_odir+"/"+encid+"/"+model1+"/interpret/full_"+encid+".counts_scores_compressed.h5"
					if os.path.exists(interf):
						files_used['fold_0'].append(interf)
			

for idx in range(1,5):
	filen=odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/"+encid+".counts_v2.bigwig"
	if os.path.exists(filen):
		num_models.append(filen)

		files_used['fold_'+str(idx)].append(filen)

		interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/interpret/full_"+encid+".counts_scores_compressed.h5"
		if os.path.exists(interf):
			files_used['fold_'+str(idx)].append(interf)
	
		interf=n_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/full_"+encid+".counts_scores_compressed_v2.h5"
		if os.path.exists(interf):
			files_used['fold_'+str(idx)].append(interf)
	
		interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/full_"+encid+".interpreted_regions_counts_v2.bed"
		if os.path.exists(interf):
			files_used['fold_'+str(idx)].append(interf)
		
		if 'selected regions bed' not in files_used:
			files_used['selected regions bed'] = interf

	else:
		interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/interpret/full_"+encid+".interpreted_regions_counts.bed"
		if os.path.exists(interf):
			numl = len(open(interf).readlines())
			peaksn = old_odir+"/"+encid+"/preprocessing/downloads/peaks.bed.gz"
			df = pd.read_csv(peaksn, sep="\t",header=None)
			if df.shape[0] == numl:
				files_used['fold_'+str(idx)].append(interf)
				filep = old_bdir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/full_"+encid+".counts.bigwig"
				if os.path.exists(filep):
					num_models.append(filep)
					files_used['fold_'+str(idx)].append(filep)
				elif os.path.exists(old_bdir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/test_"+encid+".counts.bigwig"):
					num_models.apppend(old_bdir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/test_"+encid+".counts.bigwig")
					files_used['fold_'+str(idx)].append(old_bdir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/test_"+encid+".counts.bigwig")
				else:
					print(filep)

				if len(num_models) == 5:
					if 'selected regions bed' not in files_used:
						files_used['selected regions bed'] = interf
		
				if len(num_models) == idx+1:
					interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/interpret/full_"+encid+".counts_scores_compressed.h5"
					if os.path.exists(interf):
						files_used['fold_'+str(idx)].append(interf)
		

		else:
			interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/interpret/full_"+encid+".interpreted_regions.bed"
			if os.path.exists(interf):
				numl = len(open(interf).readlines())
				df = pd.read_csv(peaksn, sep="\t",header=None)
				if df.shape[0] == numl:
					files_used['fold_'+str(idx)].append(interf)
					filep = old_bdir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/full_"+encid+".counts.bigwig"
					if os.path.exists(filep):
						num_models.append(filep)
						files_used['fold_'+str(idx)].append(filep)
					else:
						print(filep)
				
				if len(num_models) == 5:
					if 'selected regions bed' not in files_used:
						files_used['selected regions bed'] = interf
					
	
				if len(num_models) == idx+1:
					interf=old_odir+"/"+encid+"/"+model1+"_fold_"+str(idx)+"/interpret/full_"+encid+".counts_scores_compressed.h5"
					if os.path.exists(interf):
						files_used['fold_'+str(idx)].append(interf)
						

if len(num_models) == 5:
	output_path=odir+"/"+encid+"/mean_bigwig/full_mean_"+encid+".counts.bigwig"
	command = ["bash"]
	command += ["combine_bigwigs.sh"]
	command += num_models
	command += [output_path]
	cmd = " ".join(command)
	#total_num+=1
	#print(encid)
	print(cmd)
	os.system(cmd)
	
	output_path=odir+"/"+encid+"/mean_bigwig/full_mean_"+encid+".counts.json"
	with open(output_path, "w") as outfile:
		json.dump(files_used, outfile, indent=4)

else:
	print(num_models)
	print(encid)

