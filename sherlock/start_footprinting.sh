#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bias_model=$5
fold_num=$6

#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_encsr880cub_bias
#chrombpnet_model_encsr146kfx_bias
#chrombpnet_model_feb15
#chrombppnet_model_encsr283tme_bias

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombppnet_model_encsr283tme_bias/footprints/corrected_footprints_score.txt ]] ; then
        echo "skipping footprinting"
    else
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.footprinting \
            -p akundaje,owners -t 1:00:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=30G \
            -o $oak_dir/$experiment/chrombppnet_model_encsr283tme_bias/footprints/footprinting.log.o \
            -e $oak_dir/$experiment/chrombppnet_model_encsr283tme_bias/footprints/footprinting.log.e \
            run_footprinting.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bias_model $fold_num
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






