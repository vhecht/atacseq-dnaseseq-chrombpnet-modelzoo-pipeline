#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bias_model=$5
foldnum=$6

#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_encsr880cub_bias
#chrombpnet_model_encsr146kfx_bias
#chrombpnet_model_feb15
#chrombpnet_model_feb15_fold_2
#/chrombpnet_model_encsr000ekp_bias_fold_$foldnum

#chrombppnet_model_encsr283tme_bias_fold_2

if [[ -f  $oak_dir/$experiment/preprocessing/bigWigs/$experiment.bigWig ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model_feb15_fold_$foldnum/chrombpnet_wo_bias.h5 ]] ; then
        echo "skipping modeling"
    else
        mkdir $oak_dir/$experiment/
        wait
        mkdir $oak_dir/$experiment/chrombpnet_model_feb15_fold_$foldnum
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.modelling \
            -p akundaje,owners -t 24:00:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=50G \
            -o $oak_dir/$experiment/chrombpnet_model_feb15_fold_$foldnum/modelling.log.o \
            -e $oak_dir/$experiment/chrombpnet_model_feb15_fold_$foldnum/modelling.log.e \
            run_modelling.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/ $bias_model $foldnum chrombpnet_model_feb15_fold_$foldnum
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






