import os

oakd="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/DNASE/"

#model=["chrombpnet_model_encsr880cub_bias","chrombppnet_model_encsr880cub_bias_fold_1","chrombppnet_model_encsr880cub_bias_fold_2","chrombppnet_model_encsr880cub_bias_fold_3","chrombppnet_model_encsr880cub_bias_fold_4"]
#model=["chrombpnet_model_feb15_fold_0", "chrombpnet_model_feb15_fold_1", "chrombpnet_model_feb15_fold_2", "chrombpnet_model_feb15_fold_3", "chrombpnet_model_feb15_fold_4"]
#model = ["chrombppnet_model_encsr283tme_bias", "chrombppnet_model_encsr283tme_bias_fold_1", "chrombppnet_model_encsr283tme_bias_fold_2", "chrombppnet_model_encsr283tme_bias_fold_3", "chrombppnet_model_encsr283tme_bias_fold_4"]
#model = ["chrombpnet_model_encsr146kfx_bias", "chrombpnet_model_encsr146kfx_bias_fold_1", "chrombpnet_model_encsr146kfx_bias_fold_2", "chrombpnet_model_encsr146kfx_bias_fold_3", "chrombpnet_model_encsr146kfx_bias_fold_4"]

#data1 = open("../combine_deepshaps/tissue_passed.txt").readlines()
#data = [line.strip() for line in  data1]
#data1 = open("tissue_pending.txt").readlines()
#data1 = open("tissue_http_error.txt").readlines()
#data = [line.strip() for line in  data1]

#model="chrombpnet_model_encsr880cub_bias"
#model="chrombppnet_model_encsr880cub_bias_fold_4"



data1 = open("../combine_deepshaps/celline_passed.txt").readlines()
data = [line.strip() for line in  data1]
#data1 = open("../combine_deepshaps/celline_pending.txt").readlines()
#data += [line.strip() for line in  data1]
model="chrombpnet_model_feb15_fold_1"

#data1 = open("../combine_deepshaps/primary_passed.txt").readlines()
#data1 = open("primary_out_error.txt").readlines()
#data = [line.strip() for line in  data1]
#model="chrombppnet_model_encsr283tme_bias"
#model="chrombppnet_model_encsr283tme_bias_fold_4"
#data1 = open("primary_pending.txt").readlines()
#data += [line.strip() for line in  data1]


#data1 = open("../combine_deepshaps/invitro.txt").readlines()
#data = [line.strip() for line in  data1]
#model="chrombpnet_model_encsr146kfx_bias"
#model="chrombpnet_model_encsr146kfx_bias_fold_4"

#print(len(data))

for encode_id in data:
#for encode_id in ["ENCSR696XSJ"]:
        command = "bash start_shap_fill.sh "+encode_id+" "+model+" "+oakd+" DNASE"
        os.system(command)
        print(command)
