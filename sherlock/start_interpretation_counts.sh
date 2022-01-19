#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/interpret_counts_full/$experiment.counts_scores.h5 ]] ; then
            echo "count interpretations already exist - skipping"
        else
            if [[ ! -f $output_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
                echo "copying model form oak"
                mkdir $output_dir/$experiment/chrombpnet_model/
                cp $oak_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 $output_dir/$experiment/chrombpnet_model/
                
            fi
            mkdir $output_dir/$experiment/interpret_counts_full/
            cores=1
            sbatch --export=ALL --requeue \
                -J $experiment.count.interpret \
                -p akundaje,gpu,owners -t 48:00:00 \
                -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                --mem=80G \
                -o $output_dir/$experiment/interpret_counts_full/interpret.log.o \
                -e $output_dir/$experiment/interpret_counts_full/interpret.log.e \
                run_interpretation_counts.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






