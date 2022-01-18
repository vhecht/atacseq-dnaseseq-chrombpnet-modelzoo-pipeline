#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

#ml python/3.6.1
#ml py-numpy/1.18.1_py36
#export PYTHONPATH=$PYTHONPATH:/home/users/anusri/.local/lib/python3.6/site-packages/
#export PATH=$PATH:/home/groups/akundaje/annashch/miniconda3/bin

if [[ -d $output_dir/$experiment ]] ; then
    if [[ -f $output_dir/$experiment/chrombpnet_model/interpret/$experiment.profile_scores.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/modisco_results_allChroms_profile.hdf5 ]] ; then
            echo "modisco run exists"
        else
            mkdir $oak_dir/$experiment
            scores_prefix=$output_dir/$experiment/chrombpnet_model/interpret/$experiment
            modisco_dir=$oak_dir/$experiment
            cell_type=$experiment  

            cores=20
            score_type=profile
            sbatch --export=ALL --requeue \
                -J $experiment.modisco \
                -p owners,akundaje \
                -t 720 -c $cores --mem=150G \
                -o $modisco_dir/profile.file.log.o \
                -e $modisco_dir/profile.file.log.e \
                run_modisco.sh  $scores_prefix $modisco_dir $score_type $cell_type $output_dir/$experiment/
        fi
    else
        echo "do interpretation step first"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






