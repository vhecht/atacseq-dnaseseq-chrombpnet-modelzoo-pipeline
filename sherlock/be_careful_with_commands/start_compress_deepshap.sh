#!/bin/sh

experiment=$1
modelname=$2
oakdir=$3

if [[ -f $oakdir/$experiment/$modelname/interpret/full_$experiment".profile_scores.h5" || -f $oakdir/$experiment/$modelname/interpret/full_$experiment".counts_scores.h5" ]] ; then
    echo "bias profiles found"
    echo $oakdir/$experiment/$modelname/interpret/full_$experiment".profile_scores.h5"
    echo $oakdir/$experiment/$modelname/interpret/full_$experiment".counts_scores.h5"
    mkdir log_files/$experiment
    cores=2
    sbatch --export=ALL --requeue \
        -J $experiment.compress.deepshap \
        -p owners,akundaje -t 00:15:00 \
        -c $cores --mem=80G \
        -o log_files/$experiment/$modelname.compress.deepshap.log.o \
        -e log_files/$experiment/$modelname.compress.deepshap.log.e \
        run_compress_deepshap.sh $experiment $modelname $oakdir
else
    echo $oakdir/$experiment/$modelname/interpret/full_$experiment".profile_scores.h5"
    echo $oakdir/$experiment/$modelname/interpret/full_$experiment".counts_scores.h5"
    echo "nothing to do"
fi
