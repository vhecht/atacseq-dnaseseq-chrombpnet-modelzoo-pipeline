import os

oakd="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"

model=["chrombpnet_model_encsr880cub_bias","chrombppnet_model_encsr880cub_bias_fold_1","chrombppnet_model_encsr880cub_bias_fold_2","chrombppnet_model_encsr880cub_bias_fold_3","chrombppnet_model_encsr880cub_bias_fold_4"]
#model=["chrombpnet_model_feb15_fold_0", "chrombpnet_model_feb15_fold_1", "chrombpnet_model_feb15_fold_2", "chrombpnet_model_feb15_fold_3", "chrombpnet_model_feb15_fold_4"]
#model = ["chrombppnet_model_encsr283tme_bias", "chrombppnet_model_encsr283tme_bias_fold_1", "chrombppnet_model_encsr283tme_bias_fold_2", "chrombppnet_model_encsr283tme_bias_fold_3", "chrombppnet_model_encsr283tme_bias_fold_4"]
#model = ["chrombpnet_model_encsr146kfx_bias", "chrombpnet_model_encsr146kfx_bias_fold_1", "chrombpnet_model_encsr146kfx_bias_fold_2", "chrombpnet_model_encsr146kfx_bias_fold_3", "chrombpnet_model_encsr146kfx_bias_fold_4"]

#running=["ENCSR524DWS", "ENCSR941DTJ", "ENCSR155NPL"]



#data1 = open("tissue_passed.txt").readlines()
#data = [line.strip() for line in  data1]
#data1 = open("tissue_pending.txt").readlines()
#data += [line.strip() for line in  data1]


#data1 = open("celline_passed.txt").readlines()
#data = [line.strip() for line in  data1]
#data1 = open("celline_pending.txt").readlines()
#data += [line.strip() for line in  data1]

#data1 = open("primary_passed.txt").readlines()
#data = [line.strip() for line in  data1]
#data1 = open("primary_pending.txt").readlines()
#data += [line.strip() for line in  data1]


data1 = open("invitro.txt").readlines()
data = [line.strip() for line in  data1]

print(len(data))

#for encode_id in ["ENCSR941DTJ"]:
#for encode_id in ["ENCSR772HUG"]:

#running = ["ENCSR704HNG"]

#for encode_id in ["ENCSR704HNG"]:
for encode_id in data:

	#if encode_id in running:
	#	continue

	#command = "bash start_combine_deepshap.sh "+encode_id+" "+model[0]+" "+model[1]+" "+model[2]+" "+model[3]+" "+model[4]+" "+oakd+" DNASE"
	#os.system(command)
	#print(command)

	command = "bash start_modisco_lite.sh "+encode_id+" DNASE"
	os.system(command)
	print(command)

