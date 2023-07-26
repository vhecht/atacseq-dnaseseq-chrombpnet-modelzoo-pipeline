#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3
bias_threshold=$4
fold_num=$5
modelname=$6

output_dir=$dir/$modelname/bias_model/
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

#cp $blacklist $output_dir
#cp /scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_$fold".json" $output_dir
#cp $oak_dir/preprocessing/downloads/peaks.bed.gz $output_dir
#cp $reference_dir/chrom.sizes $output_dir
#cp $reference_dir/hg38.genome.fa $output_dir
#cp $reference_dir/hg38.genome.fa.fai $output_dir
#cp $oak_dir/preprocessing/negatives_data_new/fold_"$fold"/"$experiment"_negatives.bed  $output_dir
#cp $oak_dir/preprocessing/bigWigs/$experiment".bigWig"  $output_dir

if [[ -f $output_dir/auxiliary/$experiment"_30K_subsample_peaks.bed" ]] ; then
    echo "interpretation bed exists"
else
    zcat $oak_dir/preprocessing/downloads/peaks.bed.gz | shuf -n 30000 > $output_dir/auxiliary/$experiment"_30K_subsample_peaks.bed"
fi

wait

if [[ -f $output_dir/auxiliary/interpret_subsample/$experiment"_bias.counts_scores.h5" ]] ; then
    echo "counts interpret exists"
    if [[ -f $output_dir/auxiliary/interpret_subsample/$experiment"_bias.profile_scores.h5" ]] ; then
        echo "profile interpret exists"
    else
        echo "running profile interpret"
        singularity exec --nv  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet contribs_bw -m $output_dir/models/$experiment"_bias.h5" -r $output_dir/auxiliary/$experiment"_30K_subsample_peaks.bed" -g $reference_dir/hg38.genome.fa -c $reference_dir/chrom.sizes -op  $output_dir/auxiliary/interpret_subsample/$experiment"_bias"  -pc profile
    fi
else
    echo "running both counts and profile interpret"
    mkdir $output_dir/auxiliary/interpret_subsample/
    singularity exec --nv  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet contribs_bw -m $output_dir/models/$experiment"_bias.h5" -r $output_dir/auxiliary/$experiment"_30K_subsample_peaks.bed" -g $reference_dir/hg38.genome.fa -c $reference_dir/chrom.sizes -op  $output_dir/auxiliary/interpret_subsample/$experiment"_bias"
fi

wait

if [[ -f $output_dir/evaluation/modisco_profile/motifs.html ]] ; then
    echo "profile modisco exists"

    if [[ -f $output_dir/evaluation/modisco_counts/motifs.html ]] ; then
        echo "counts modisco exists"
    else
        echo "running counts modisco"
        singularity exec  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet modisco_motifs -i $output_dir/auxiliary/interpret_subsample/$experiment"_bias.counts_scores.h5" -n 50000 -op $output_dir/evaluation/modisco_counts 
        wait
        mv $output_dir/evaluation/modisco_counts_reports/ $output_dir/evaluation/modisco_counts/
        wait
        mv $output_dir/evaluation/modisco_counts_modisco.h5 $output_dir/auxiliary/interpret_subsample/$experiment"_modisco_results_counts_scores.h5"
    fi
else
    echo "running both counts and profile modisco"

    singularity exec  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet modisco_motifs -i $output_dir/auxiliary/interpret_subsample/$experiment"_bias.profile_scores.h5" -n 50000 -op $output_dir/evaluation/modisco_profile 
    wait
    mv $output_dir/evaluation/modisco_profile_reports/ $output_dir/evaluation/modisco_profile/
    wait
    mv $output_dir/evaluation/modisco_profile_modisco.h5 $output_dir/auxiliary/interpret_subsample/$experiment"_modisco_results_profile_scores.h5"

    singularity exec  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet modisco_motifs -i $output_dir/auxiliary/interpret_subsample/$experiment"_bias.counts_scores.h5" -n 50000 -op $output_dir/evaluation/modisco_counts 
    wait
    mv $output_dir/evaluation/modisco_counts_reports/ $output_dir/evaluation/modisco_counts/
    wait
    mv $output_dir/evaluation/modisco_counts_modisco.h5 $output_dir/auxiliary/interpret_subsample/$experiment"_modisco_results_counts_scores.h5"

fi

singularity exec   /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif python /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet/chrombpnet/helpers/generate_reports/make_html_bias.py -id $output_dir -fp $experiment

wait


#rm $output_dir/blacklist_slop1057.bed
#rm $output_dir/fold_$fold".json"
#rm $output_dir/chrom.sizes
#rm $output_dir/hg38.genome.fa
#rm $output_dir/hg38.genome.fa.fai
#rm $output_dir/"$experiment"_negatives.bed
#rm $output_dir/$experiment".bigWig"

