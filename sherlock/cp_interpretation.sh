#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $output_dir/$experiment/chrombpnet_model_feb15/interpret/full_$experiment.counts_scores.h5 ]] ; then
            echo "counts interpretations already exist - skipping"
            if [[ -f $oak_dir/$experiment/chrombpnet_model_feb15/interpret/full_$experiment.counts_scores.h5 ]] ; then
                echo "nothing to do"
            else
               echo "copying"
               cp $output_dir/$experiment/chrombpnet_model_feb15/interpret/full_$experiment.counts_scores.h5 $oak_dir/$experiment/chrombpnet_model_feb15/interpret/                  
            fi
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






