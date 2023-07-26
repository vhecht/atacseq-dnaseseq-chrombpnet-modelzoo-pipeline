#!/bin/sh

experiment=$1
modelname=$2
oak_dir=$3
type=$4

outdir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/full_deepshaps/$type/
bigwigdir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/full_deepshaps/bigwigs/$type/

if [[ -f $bigwigdir/$experiment/$modelname/$experiment".profile_v2.bigwig" ]] ; then
    echo "mean profile found do nothing"
else
    if [[ -f /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/bigwigs/$experiment/$modelname/$experiment".profile_v2.bigwig" ]] ; then
        echo "mean profile found do nothing"
    else
        mkdir $outdir/$experiment/
        mkdir $bigwigdir/$experiment/
        mkdir $outdir/$experiment/$modelname
        mkdir $bigwigdir/$experiment/$modelname
        cores=2

        if [[ "$type" = "ATAC" ]] ; then
            sbatch --export=ALL --requeue \
                -J $experiment.fill.profile \
                -p owners,akundaje -t 24:00:00 \
	        -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
	        --mem=80G \
                -o $outdir/$experiment/$modelname/fill.profile.log.o \
                -e $outdir/$experiment/$modelname/fill.profile.log.e \
                run_shap_fill.sh $oak_dir/$experiment $modelname $outdir/$experiment/$modelname/$experiment $experiment profile $bigwigdir/$experiment/$modelname/$experiment

        elif [[ "$type" = "DNASE" ]] ; then
            mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/$type/$experiment/
            mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/$type/$experiment/$modelname/

            sbatch --export=ALL --requeue \
                -J $experiment.fill.profile \
                -p owners,akundaje -t 24:00:00 \
	        -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
	        --mem=80G \
                -o /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/$type/$experiment/$modelname/fill.profile.log.o \
                -e /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/$type/$experiment/$modelname/fill.profile.log.e \
                run_shap_fill_dnase_profile.sh $oak_dir/$experiment $modelname $outdir/$experiment/$modelname/$experiment $experiment profile $bigwigdir/$experiment/$modelname/$experiment

        else
            echo "unknown "$type 
        fi
    fi
fi


