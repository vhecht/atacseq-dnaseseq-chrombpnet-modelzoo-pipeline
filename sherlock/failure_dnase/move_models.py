import pandas as pd
import os

dict_models = {"stage1_bias_models_thresh_0.8.txt":"chrombpnet_model_feb15_fold_0",
	"stage2_bias_models_thresh_0.6.txt":"chrombpnet_model_feb20_fold_0",
	"stage3_bias_models_thresh_0.4.txt":"chrombpnet_model_feb22_fold_0",
	"recheck_set_and_some_extras_0.6.txt":"chrombpnet_model_feb20_fold_0",}


sheet_rows = []
for key in dict_models:
	encode_id = open(key).readlines()
	encode_id = [x.strip() for x in encode_id]
	for id in encode_id[1:]:
		mpath = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+"/chrombpnet_model/models/"+id+"_chrombpnet_nobias.h5"
		print(mpath)

		if os.path.exists(mpath):
			#os.system("mkdir /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/archive/")
			#d = "/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/"
			#old_models = [os.path.join(d, o) for o in os.listdir(d) if (os.path.isdir(os.path.join(d,o))) and ("_model" in o)]
			#for patho in old_models:
			#	command = "mv "+patho+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/archive/"
			#	print(command)
			#	os.system(command)
			#command = "tar -czvf "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/archive.tar.gz"+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/archive/"  
			#print(command)
			#tar_run = os.system(command)
			#assert tar_run.returncode == 0, "Running tar returned an error"
			
			#command = "rm -r "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/archive/"
			#print(command)
			#os.system(command)

			command = "mkdir "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"
			print(command)
			os.system(command)

			command = "cp -r /scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key]+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"				
			print(command)
			os.system(command)

			mpath1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_1")+"/chrombpnet_model/models/"+id+"_chrombpnet_nobias.h5"
			print(mpath1)
			if os.path.exists(mpath1):
				command = "cp -r /scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_1")+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"				
				print(command)
				os.system(command)

			mpath1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_2")+"/chrombpnet_model/models/"+id+"_chrombpnet_nobias.h5"
			print(mpath1)
			if os.path.exists(mpath1):
				command = "cp -r /scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_2")+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"				
				print(command)
				os.system(command)


			mpath1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_3")+"/chrombpnet_model/models/"+id+"_chrombpnet_nobias.h5"
			print(mpath1)
			if os.path.exists(mpath1):
				command = "cp -r /scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_3")+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"				
				print(command)
				os.system(command)


			mpath1 = "/scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_4")+"/chrombpnet_model/models/"+id+"_chrombpnet_nobias.h5"
			print(mpath1)
			if os.path.exists(mpath1):
				command = "cp -r /scratch/groups/akundaje/anusri/chromatin_atlas/DNASE/"+id+"/"+dict_models[key].replace("fold_0", "fold_4")+" "+"/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"+id+"/failed_models_retrained/"				
				print(command)
				os.system(command)

			

