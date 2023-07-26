#!/bin/sh

experiment=$1
type=$2

indir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/mean_deepshaps/$type/
outdir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/mean_deepshaps_modisco/$type/
oak_dir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/$type/

if [[ -f $indir/$experiment/$experiment".mean_shap.counts_scores_compressed.h5" ]] ; then
        if [[ -f $outdir/$experiment/$experiment".modisco.counts.h5" ]] ; then
            echo "modisco run exists"
        else
            mkdir $outdir/$experiment/
            scores_prefix=$indir/$experiment/$experiment".mean_shap"
            modisco_dir=$outdir/$experiment/
            score_type=counts
            cell_type=$experiment
            regions_prefix=$indir/$experiment/$experiment".interpreted_counts.bed"

            cores=20
            sbatch --export=ALL --requeue \
                -J $experiment.modisco.counts \
                -p owners,akundaje \
                -t 30:00:00 -c $cores --mem=60G \
                -o $outdir/$experiment/counts.file.log.o \
                -e $outdir/$experiment/counts.file.log.e \
                run_modisco_lite_compressed.sh  $scores_prefix $modisco_dir $score_type $cell_type $regions_prefix $oak_dir/$experiment/
        fi
    else
        echo "do interpretation step first"
    fi





