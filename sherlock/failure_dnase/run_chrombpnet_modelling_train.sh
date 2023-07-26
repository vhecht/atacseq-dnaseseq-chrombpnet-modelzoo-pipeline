#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3
fold_num=$4
modelname=$5
modelname1=$6

output_dir=$dir/$modelname/chrombpnet_model/
fold=$fold_num
rm -r $output_dir/logs/
rm -r $output_dir/evaluation/
rm -r $output_dir/models/
rm -r $output_dir/auxiliary/
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

singularity exec --nv /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif nvidia-smi
singularity exec --nv  /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif chrombpnet train -ibw $oak_dir/preprocessing/bigWigs/$experiment".bigWig" -d $data_type -g $reference_dir/hg38.genome.fa -c  $reference_dir/chrom.sizes -p $oak_dir/preprocessing/downloads/peaks.bed.gz -n $oak_dir/preprocessing/negatives_data_new/fold_"$fold"/"$experiment"_negatives.bed -fl /scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_$fold".json" -b $dir/$modelname1/bias_model/models/$experiment"_bias.h5" -o $output_dir -fp $experiment

wait


#rm $output_dir/blacklist_slop1057.bed
#rm $output_dir/fold_$fold".json"
#rm $output_dir/chrom.sizes
#rm $output_dir/hg38.genome.fa
#rm $output_dir/hg38.genome.fa.fai
#rm $output_dir/"$experiment"_negatives.bed
#rm $output_dir/$experiment".bigWig"

