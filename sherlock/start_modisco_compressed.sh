#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
oak_old_dir=$5

#ml python/3.6.1
#ml py-numpy/1.18.1_py36
#export PYTHONPATH=$PYTHONPATH:/home/users/anusri/.local/lib/python3.6/site-packages/
#export PATH=$PATH:/home/groups/akundaje/annashch/miniconda3/bin

#chrombpnet_model_encsr880cub_bias
#chrombpnet_model
#primary/immune
#chrombppnet_model_encsr283tme_bias
#ranked_encsr283tme_bias
#invitro
#chrombpnet_model_encsr146kfx_bias

if [[ -d $output_dir/$experiment ]] ; then
    echo "$oak_old_dir/$experiment/chrombpnet_model/interpret/full_compressed_$experiment.counts_scores.h5"
    if [[ -f $oak_old_dir/$experiment/chrombpnet_model/interpret/full_compressed_$experiment.counts_scores.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/full_feb15_compressed1/modisco_results_allChroms_counts.hdf5 ]] ; then
            echo "modisco run exists"
        else
            mkdir $oak_dir/$experiment/
            mkdir $oak_dir/$experiment/full_feb15_compressed1/
            modisco_dir=$oak_dir/$experiment/full_feb15_compressed1/ 
            scores_prefix=$oak_old_dir/$experiment/chrombpnet_model/interpret/full_compressed_$experiment
            regions_prefix=$oak_old_dir/$experiment/chrombpnet_model/interpret/full_$experiment.interpreted_regions_counts.bed
            cell_type=$experiment  

            cores=20
            score_type=counts
            sbatch --export=ALL --requeue \
                -J $experiment.modisco \
                -p owners,akundaje \
                -t 5:00:00 -c $cores --mem=30G \
                -o $modisco_dir/counts1.file.log.o \
                -e $modisco_dir/counts1.file.log.e \
                run_modisco_lite_compressed.sh  $scores_prefix $modisco_dir $score_type $cell_type $output_dir/$experiment/ $oak_dir/$experiment/ $regions_prefix $oak_old_dir/$experiment/
        fi
    else
        echo "do interpretation step first"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






