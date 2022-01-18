#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3
bias_model=$4

cd chrombpnet

cp -r $oak_dir/preprocessing $dir
cp -r $oak_dir/negatives_data $dir

reference_fasta=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa
bigwig_path=$dir/preprocessing/bigWigs/$experiment.bigWig
overlap_peak=$dir/preprocessing/downloads/peaks.bed.gz
nonpeaks=$dir/negatives_data/negatives_with_summit.bed
fold=/scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_0.json
output_dir=$dir/chrombpnet_model/
pipeline_json=$dir/preprocessing/params_file.json
assay_type=`jq .assay_type $pipeline_json | sed 's/"//g'`
echo $assay_type
if [ "$assay_type" = "DNase-seq" ] ; then
    data_type="DNASE_SE"
elif [ "$assay_type" = "ATAC-seq" ] ; then
    data_type="ATAC_PE"
else
    data_type="unknown"
fi
echo $data_type

singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash step6_train_chrombpnet_model.sh $reference_fasta $bigwig_path $overlap_peak $nonpeaks $fold $bias_model $output_dir $data_type
wait
cp -r $output_dir $oak_dir
