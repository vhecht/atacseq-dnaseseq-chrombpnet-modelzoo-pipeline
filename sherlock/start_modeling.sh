#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3

if [[ -d $output_dir/$experiment ]] ; then
    if [[ -d $output_dir/$experiment/chrombpnet_model ]] ; then
        echo "skipping modeling"
    else
        mkdir $output_dir/$experiment/chrombpnet_model
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiement.modelling \
            -p owners,akundaje -t 720 \
            -G 1 -c 1 \
            --mem=80G \
            -o $output_dir/$experiment/chrombpnet_model/modelling.log.o \
            -e $output_dir/$experiment/chrombpnet_model/modelling.log.e \
            run_modelling.sh $experiment $output_dir/$experiment/
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






