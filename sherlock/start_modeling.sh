#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bias_model=$5

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
        echo "skipping modeling"
    else
        mkdir $output_dir/$experiment/
        mkdir $output_dir/$experiment/chrombpnet_model
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.modelling \
            -p akundaje,gpu,owners -t 24:00:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=30G \
            -o $output_dir/$experiment/chrombpnet_model/modelling.log.o \
            -e $output_dir/$experiment/chrombpnet_model/modelling.log.e \
            run_modelling.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bias_model
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






