#!/bin/sh

experiment=$1
modelname=$2
modelname1=$3
modelname2=$4
modelname3=$5
modelname4=$6
oak_dir=$7
type=$8

outdir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/mean_deepshaps/$type/

if [[ -f $outdir/$experiment/$experiment".mean_shap.profile_scores_compressed.h5" ]] ; then
    echo "mean profile found do nothing"
else
    mkdir $outdir/$experiment/
    cores=2
    sbatch --export=ALL --requeue \
        -J $experiment.mean.ds.profile \
        -p owners,akundaje -t 00:15:00 \
        -c $cores --mem=50G \
        -o $outdir/$experiment/mean.profile.deepshap.log.o \
        -e $outdir/$experiment/mean.profile.deepshap.log.e \
        run_combine_deepshap.sh $oak_dir/$experiment $modelname $modelname1 $modelname2 $modelname3 $modelname4 $outdir/$experiment/$experiment $experiment profile
fi
