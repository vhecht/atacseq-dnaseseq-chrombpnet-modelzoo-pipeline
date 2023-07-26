#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
bw_oak_dir=$4
oak_dir=$5

#chrombpnet_model_encsr146kfx_bias
#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_feb15
#chrombpnet_model_feb15_fold_4


if [[ -f $oak_dir/$experiment/chrombpnet_model_feb15_fold_4/chrombpnet_wo_bias.h5 ]] ; then
    if [[ -f $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/all.$experiment"_wo_bias.bw" ]] ; then
        echo "skipping prediction bigwig already exists"
    else
       #if [[ -f $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_wo_bias.bw" ]] ; then
       #    rm $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_wo_bias.bw"
       #    rm $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_wo_bias.stats.txt"
       #fi

       #if [[ -f $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_w_bias.bw" ]] ; then
       #    rm $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_w_bias.bw"
       #    rm $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"_w_bias.stats.txt"
       #fi

       #if [[ -f $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"bias.bw" ]] ; then
       #    rm $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/$experiment"bias.bw"
       #fi

        mkdir $bw_oak_dir/$experiment/
        mkdir $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.fold_4.preds \
            -p akundaje,owners -t 00:60:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=80G \
            -o $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/preds.log.o \
            -e $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4/preds.log.e \
             #run_prediction.sh $experiment $oak_dir/$experiment/ $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4 chrombpnet_model_feb15
             run_prediction.sh $experiment $oak_dir/$experiment/ $bw_oak_dir/$experiment/chrombpnet_model_feb15_fold_4 chrombpnet_model_feb15_fold_4

    fi
else
    echo "missing model"
fi






