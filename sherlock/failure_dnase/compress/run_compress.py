import pandas as pd
import os

dict_models = {"../stage1_bias_models_thresh_0.8.txt":"chrombpnet_model_feb15_fold_0",
	"../stage2_bias_models_thresh_0.6.txt":"chrombpnet_model_feb20_fold_0",
	"../stage3_bias_models_thresh_0.4.txt":"chrombpnet_model_feb22_fold_0",
	"../recheck_set_and_some_extras_0.6.txt":"chrombpnet_model_feb20_fold_0",}


sheet_rows = []
for key in dict_models:
	encode_id = open(key).readlines()
	encode_id = [x.strip() for x in encode_id]
	for id in encode_id:
		interpret1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/chrombpnet_model/auxiliary/interpret_subsample/"+id+"_chrombpnet_nobias.profile_scores.h5"
		outp1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/chrombpnet_model/auxiliary/interpret_subsample/"+id+"_chrombpnet_nobias.profile_scores"
		print(interpret1)
		if os.path.exists(interpret1):
			command = "singularity run  /home/groups/akundaje/anusri/simg/modisco_lite.sif python compress_deepshap.py -i "+interpret1+" -o "+outp1
			os.system(command)

		interpret1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/bias_model/auxiliary/interpret_subsample/"+id+"_bias.profile_scores.h5"
		outp1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/bias_model/auxiliary/interpret_subsample/"+id+"_bias.profile_scores"
		print(interpret1)
		if os.path.exists(interpret1):
			command = "singularity run  /home/groups/akundaje/anusri/simg/modisco_lite.sif python compress_deepshap.py -i "+interpret1+" -o "+outp1
			print(command)
			os.system(command)


		interpret1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/bias_model/auxiliary/interpret_subsample/"+id+"_bias.counts_scores.h5"
		outp1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/bias_model/auxiliary/interpret_subsample/"+id+"_bias.counts_scores"
		print(interpret1)
		if os.path.exists(interpret1):
			command = "singularity run  /home/groups/akundaje/anusri/simg/modisco_lite.sif python compress_deepshap.py -i "+interpret1+" -o "+outp1
			print(command)
			os.system(command)



