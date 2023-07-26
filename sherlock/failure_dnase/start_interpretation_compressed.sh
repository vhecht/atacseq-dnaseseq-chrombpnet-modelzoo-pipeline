#!/bin/sh

experiment=$1
oak_dir=$2
bigwig_dir=$3
modelname=$4

if [[ -d $oak_dir/$experiment ]] ; then
    echo $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/models/$experiment"_chrombpnet_nobias.h5"
    if [[ -f $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/models/$experiment"_chrombpnet_nobias.h5" ]] ; then
        if [[ -f $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/interpret/full_$experiment.profile_scores_compressed.h5 ]] ; then
            echo "profile interpretations already exist - skipping"         
        else
            mkdir $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/interpret/
            mkdir $bigwig_dir/$experiment/failed_models_retrained/
            mkdir $bigwig_dir/$experiment/failed_models_retrained/$modelname/

            cores=1
            sbatch --export=ALL --requeue \
                -J $experiment.interpret  \
                -p akundaje,owners -t 24:00:00 \
                -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
                --mem=80G \
                -o $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/interpret/full.profile3.interpret.log.o \
                -e $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/interpret/full.profile3.interpret.log.e \
                run_interpretation_compressed_profile.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/failed_models_retrained/$modelname/chrombpnet_model/ $bigwig_dir/$experiment/failed_models_retrained/$modelname/
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi




