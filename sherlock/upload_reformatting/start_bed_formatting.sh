#!/bin/sh

experiment=$1
oak_dir=$2
fold=$3
modelname=$4

if [[ -f $oak_dir/$experiment/$modelname/chrombpnet_wo_bias.h5 ]] ; then
    if [[ -f $oak_dir/$experiment/$modelname/train_test_regions/nonpeaks.validationset.bed.gz ]] ; then
        echo "skipping already exists"
    else
        mkdir $oak_dir/$experiment/$modelname/train_test_regions/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.$fold.pconv \
            -p akundaje,owners -t 00:10:00 \
            -c $cores --mem=5G \
            -o $oak_dir/$experiment/$modelname/train_test_regions/pconv.log.o \
            -e $oak_dir/$experiment/$modelname/train_test_regions/pconv.log.e \
             run_bed_formatting.sh $experiment $oak_dir/$experiment/ $modelname $fold 

    fi
else
    echo "missing model"
fi






