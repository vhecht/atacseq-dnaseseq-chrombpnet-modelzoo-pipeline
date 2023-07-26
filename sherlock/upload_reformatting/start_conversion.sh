#!/bin/sh

experiment=$1
oak_dir=$2
fold=$3
modelname=$4


if [[ -f $oak_dir/$experiment/$modelname/chrombpnet.h5 ]] ; then
    if [[ -f $oak_dir/$experiment/$modelname/new_model_formats/chrombpnet.tar ]] ; then
        echo "skipping dir already exists"
    else
        mkdir $oak_dir/$experiment/$modelname/new_model_formats/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.$fold.conv \
            -p akundaje,owners -t 00:10:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=20G \
            -o $oak_dir/$experiment/$modelname/new_model_formats/conv.chrombpnet.log.o \
            -e $oak_dir/$experiment/$modelname/new_model_formats/conv.chrombpnet.log.e \
             run_conversion.sh $experiment $oak_dir/$experiment/ $modelname $fold chrombpnet

    fi
else
    echo "missing model"
fi






