#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_feb15
#chrombpnet_model_encsr880cub_bias
#chrombpnet_model_encsr146kfx_bias

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment.counts_scores.h5 ]] ; then
            echo "counts interpretations already exist - skipping"
        else
            mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/
            mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/
            cores=1
            sbatch --export=ALL --requeue \
                -J $experiment.interpret \
                -p akundaje,owners -t 48:00:00 \
                -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                --mem=80G \
                -o $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full.counts3.interpret.log.o \
                -e $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full.counts3.interpret.log.e \
                run_interpretation.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






