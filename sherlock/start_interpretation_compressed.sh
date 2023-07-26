#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bigwig_dir=$5

#chrombppnet_model_encsr283tme_bias
#chrombppnet_model_encsr283tme_bias_feb15
#chrombpnet_model_encsr880cub_bias
#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_encsr146kfx_bias_fold_1
#chrombppnet_model_encsr880cub_bias_fold_
#chrombpnet_model_feb15
#chrombpnet_model_feb15
#chrombpnet_model_feb15_fold_1

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/full_$experiment.profile_scores_compressed.h5 ]] ; then
            echo "profile interpretations already exist - skipping"         
        else

            if [[ -f $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/full_$experiment.profile_scores_compressed.h5 ]] ; then
                mkdir $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/
                cp $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/full_$experiment.profile_scores_compressed.h5 $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/
            else

                # whwn doing profile for atac tissue and cell-type make check here to see if file exists in output_dir if yes then copy

                mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/
                mkdir $output_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/
                mkdir $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/
                mkdir $bigwig_dir/$experiment/
                mkdir $bigwig_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1
                #mkdir $oak_dir/$experiment/

                cores=1
                sbatch --export=ALL --requeue \
                    -J $experiment.interpret  \
                    -p akundaje,owners -t 48:00:00 \
                    -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                    --mem=80G \
                    -o $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/full.profile3.interpret.log.o \
                    -e $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/interpret/full.profile3.interpret.log.e \
                    run_interpretation_compressed_profile.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/ $bigwig_dir/$experiment/chrombpnet_model_encsr146kfx_bias_fold_1/
#                   run_interpretation_compressed.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bigwig_dir/$experiment/
            fi
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi



