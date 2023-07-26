#!/bin/sh

experiment=$1
oak_dir=$2
fold=$3
modelname=$4

#chrombpnet_model_encsr146kfx_bias
#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_feb15
#chrombpnet_model_feb15_fold_0

if [[ -f $oak_dir/$experiment/$modelname/chrombpnet_wo_bias.h5 ]] ; then
    if [[ -f $oak_dir/$experiment/$modelname/test/"chrombpnet_wo_bias_metrics.json" ]] ; then
        echo "skipping predictions already exists"
    else
        mkdir $oak_dir/$experiment/$modelname/test/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.$fold.preds \
            -p akundaje,owners -t 00:60:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=80G \
            -o $oak_dir/$experiment/$modelname/test/preds.log.o \
            -e $oak_dir/$experiment/$modelname/test/preds.log.e \
             run_prediction.sh $experiment $oak_dir/$experiment/ $modelname $fold

    fi
else
    echo "missing model"
fi






