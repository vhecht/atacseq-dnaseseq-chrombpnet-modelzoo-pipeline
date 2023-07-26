#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3
fold=$4

blacklist=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/blacklist_slop1057.bed
reference_dir=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/

#cp $blacklist $dir/preprocessing/negatives_data_new/fold_$fold/
#cp /scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_$fold".json" $dir/preprocessing/negatives_data_new/fold_$fold/
#cp $dir/preprocessing/downloads/peaks.bed.gz $dir/preprocessing/negatives_data_new/fold_$fold/
#cp $reference_dir/chrom.sizes $dir/preprocessing/negatives_data_new/fold_$fold/
#cp $reference_dir/hg38.genome.fa $dir/preprocessing/negatives_data_new/fold_$fold/ 
#cp $reference_dir/hg38.genome.fa.fai $dir/preprocessing/negatives_data_new/fold_$fold/ 

wait
#echo "singularity exec -e --no-mount hostfs --bind $dir/preprocessing/negatives_data_new/fold_$fold/:/mnt/ docker://kundajelab/chrombpnet:latest chrombpnet prep nonpeaks -g /mnt/hg38.genome.fa -p /mnt/peaks.bed.gz -c /mnt/chrom.sizes -fl /mnt/fold_$fold".json" -br /mnt/blacklist_slop1057.bed -o /mnt/$experiment"
#singularity exec -e --no-mount hostfs --bind $dir/preprocessing/negatives_data_new/fold_$fold/:/mnt/ docker://kundajelab/chrombpnet:latest chrombpnet prep nonpeaks -g /mnt/hg38.genome.fa -p /mnt/peaks.bed.gz -c /mnt/chrom.sizes -fl /mnt/fold_$fold".json" -br /mnt/blacklist_slop1057.bed -o /mnt/$experiment
singularity exec /home/groups/akundaje/anusri/simg/chrombpnet_latest/chrombpnet_bigwig_new.sif  chrombpnet prep nonpeaks -g $reference_dir/hg38.genome.fa -c $reference_dir/chrom.sizes -p $dir/preprocessing/downloads/peaks.bed.gz -fl /scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_$fold".json" -br $blacklist -o $dir/preprocessing/negatives_data_new/fold_$fold/$experiment


#wait
#rm $dir/preprocessing/negatives_data_new/fold_$fold/blacklist_slop1057.bed
#rm $dir/preprocessing/negatives_data_new/fold_$fold/fold_$fold".json"
#rm $dir/preprocessing/negatives_data_new/fold_$fold/peaks.bed.gz
#rm $dir/preprocessing/negatives_data_new/fold_$fold/chrom.sizes
#rm $dir/preprocessing/negatives_data_new/fold_$fold/hg38.genome.fa
#rm $dir/preprocessing/negatives_data_new/fold_$fold/hg38.genome.fa.fai

wait
tar -zcvf $oak_dir/preprocessing/negatives_data_new/fold_$fold/auxiliary.tar.gz $oak_dir/preprocessing/negatives_data_new/fold_$fold/$experiment"_auxiliary"

wait
rm -r $oak_dir/preprocessing/negatives_data_new/fold_$fold/$experiment"_auxiliary"


