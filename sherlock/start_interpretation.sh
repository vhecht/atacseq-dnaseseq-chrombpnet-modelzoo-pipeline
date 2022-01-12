#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

if [[ -d $output_dir/$experiment ]] ; then
    if [[ -f $output_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $output_dir/$experiment/chrombpnet_model/$expeirment.profile_scores.h5 ]] ; then
            echo "profile interpretations already exist - skipping"
        else
            mkdir $output_dir/$experiment/chrombpnet_model/interpret/
            cores=1
            sbatch --export=ALL --requeue \
                -J $experiment.interpret \
                -p akundaje,gpu,owners -t 24:00:00 \
                -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                --mem=80G \
                -o $output_dir/$experiment/chrombpnet_model/interpret/interpret.log.o \
                -e $output_dir/$experiment/chrombpnet_model/interpret/interpret.log.e \
                run_interpretation.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/chrombpnet_model/
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






