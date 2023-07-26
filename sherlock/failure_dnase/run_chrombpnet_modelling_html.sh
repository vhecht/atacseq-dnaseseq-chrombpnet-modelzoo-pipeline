#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3
fold_num=$4
modelname=$5

output_dir=$dir/$modelname/chrombpnet_model/
fold=$fold_num

pipeline_json=$oak_dir/preprocessing/params_file.json
assay_type=`jq .assay_type $pipeline_json | sed 's/"//g'`
echo $assay_type
if [ "$assay_type" = "DNase-seq" ] ; then
    data_type="DNASE"
elif [ "$assay_type" = "ATAC-seq" ] ; then
    data_type="ATAC"
else
    data_type="unknown"
fi
echo $data_type
echo $fold

blacklist=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/blacklist_slop1057.bed
reference_dir=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/


if [[ -f $output_dir/auxiliary/interpret_subsample/$experiment"_chrombpnet_nobias.profile_scores.h5" ]] ; then
    echo "profile interpret exists"
else
    echo "running profile interpret"
    singularity exec --nv  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet contribs_bw -m $output_dir/models/$experiment"_chrombpnet_nobias.h5" -r $output_dir/auxiliary/$experiment"_30K_subsample_peaks.bed" -g $reference_dir/hg38.genome.fa -c $reference_dir/chrom.sizes -op  $output_dir/auxiliary/interpret_subsample/$experiment"_chrombpnet_nobias"  -pc profile
fi

wait

if [[ -f $output_dir/evaluation/modisco_profile/motifs.html ]] ; then
    echo "profile modisco exists"
else
    echo "running both counts and profile modisco"

    singularity exec  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet modisco_motifs -i $output_dir/auxiliary/interpret_subsample/$experiment"_chrombpnet_nobias.profile_scores.h5" -n 50000 -op $output_dir/evaluation/modisco_profile
    wait
    mv $output_dir/evaluation/modisco_profile_reports/ $output_dir/evaluation/modisco_profile/
    wait
    mv $output_dir/evaluation/modisco_profile_modisco.h5 $output_dir/auxiliary/interpret_subsample/$experiment"_modisco_results_profile_scores.h5"

fi


singularity exec   /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif python /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet/chrombpnet/helpers/generate_reports/make_html.py -id $output_dir -fp $experiment -d $data_type

wait

