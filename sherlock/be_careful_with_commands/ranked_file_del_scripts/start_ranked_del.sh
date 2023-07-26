#!/bin/sh

experiment=$1
modelname=$2
oak_dir=$3

if [[ -f $oak_dir/$experiment/$modelname/interpret/ranked_$experiment".profile_scores.h5" ]] ; then
    echo "ranked file found"
    mkdir log_files/$experiment
    cores=1
    sbatch --export=ALL --requeue \
        -J $experiment.samstats \
        -p owners,akundaje -t 00:10:00 \
        -c $cores --mem=2G \
        -o log_files/$experiment/del.rank.log.o \
        -e log_files/$experiment/del.rank.log.e \
        run_ranked_file_del.sh $experiment $modelname
else
    echo "nothing to do"
fi
