#!/bin/bash

scores_prefix=$1
output_dir=$2
score_type=$3
cell_type=$4
regions_prefix=$5
old_oak=$6

cd modisco
pipeline_json=$old_oak/preprocessing/params_file.json
assay_type=`jq .assay_type $pipeline_json | sed 's/"//g'`
echo $assay_type
if [ "$assay_type" = "DNase-seq" ] ; then
    data_type="DNASE"
elif [ "$assay_type" = "ATAC-seq" ] ; then
    data_type="ATAC"
else
    data_type="unknown"
    data_type="DNASE"
fi
echo $data_type

seqlets=1000000
#seqlets=200
crop=500
meme_db=/oak/stanford/groups/akundaje/soumyak/motifs/motifs.meme.txt
vier_db=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/vierstra_logos/
regions=$regions_prefix
genome=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa


echo $scores_prefix"."$score_type"_scores_compressed.h5"
echo "$output_dir"

echo $regions

function timestamp {
    # Function to get the current time with the new line character
    # removed

    # current time
    date +"%Y-%m-%d_%H-%M-%S" | tr -d '\n'
}

echo $( timestamp )

singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash modiso-lite-1.sh $scores_prefix $output_dir $score_type $seqlets $crop $meme_db $vier_db $cell_type $data_type $regions

echo $( timestamp )

singularity exec /home/groups/akundaje/anusri/simg/modisco_lite.sif bash modiso-lite.sh $scores_prefix $output_dir $score_type $seqlets $crop $meme_db $vier_db $cell_type $data_type $regions

echo $( timestamp )

singularity exec /home/groups/akundaje/anusri/simg/modisco_lite.sif bash modiso-lite-2.sh $scores_prefix $output_dir $score_type $seqlets $crop $meme_db $vier_db $cell_type $data_type $regions


echo $( timestamp )

export PATH=$PATH:/home/groups/akundaje/annashch/miniconda3/bin
ml python/3.6.1
ml py-numpy/1.19.2_py36

python3 fetch_tomtom.py -m $output_dir/modisco_results_allChroms_$score_type.hdf5 -o $output_dir/$score_type.tomtom.tsv -d $meme_db -n 10 -th 0.3
rm $output_dir/modisco_results_allChroms_$score_type.hdf5
wait

echo $( timestamp )
