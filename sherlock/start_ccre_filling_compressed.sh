#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bigwig_dir=$5

#chrombpnet_model_encsr146kfx_bias
#chrombpnet_model_feb15_feb15
#chrombpnet_model_encsr880cub_bias
#chrombpnet_model_encsr146kfx_bias

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment.profile_scores_v2.h5 ]] ; then
            echo "profile interpretations already exist - skipping"         
        else

            if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment.profile_scores.h5 ]] ; then

                # whwn doing profile for atac tissue and cell-type make check here to see if file exists in output_dir if yes then copy

                mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/
                mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/
                mkdir $bigwig_dir/$experiment/
                mkdir $oak_dir/$experiment/

                cores=1
                sbatch --export=ALL --requeue \
                    -J $experiment.interpret  \
                    -p akundaje,owners -t 24:00:00 \
                    -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                    --mem=80G \
                    -o $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full_v2.interpret.log.o \
                    -e $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias/interpret/full_v2.interpret.log.e \
                    run_ccre_interpretation_compressed.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bigwig_dir/$experiment/
            fi

        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi



