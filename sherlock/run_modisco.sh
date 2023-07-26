#!/bin/bash

scores_prefix=$1
output_dir=$2
score_type=$3
cell_type=$4
dir=$5
modisco_dir=$6

#rm -r $modisco_dir/ranked_feb15
#chrombpnet_model_encsr880cub_bias
cd modisco
##chrombppnet_model_encsr283tme_bias

#ml python/3.6.1
#ml py-numpy/1.18.1_py36
#ml py-numpy/1.19.2_py36
#export PYTHONPATH=$PYTHONPATH:/home/users/anusri/.local/lib/python3.6/site-packages/

#chrombpnet_model_encsr146kfx_bias
pipeline_json=$dir/preprocessing/params_file.json
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

seqlets=50000
#seqlets=1000000
crop=500

meme_db=/oak/stanford/groups/akundaje/soumyak/motifs/motifs.meme.txt
vier_db=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/modisco/vierstra_logos/

#python3 run_modisco.py -s $scores_prefix -p $score_type -o $output_dir -m $seqlets -c $crop
echo "singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash script_modisco.sh $scores_prefix $score_type $output_dir $seqlets $crop"
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash script_modisco.sh $scores_prefix $score_type $output_dir $seqlets $crop


export PATH=$PATH:/home/groups/akundaje/annashch/miniconda3/bin
ml python/3.6.1
ml py-numpy/1.19.2_py36

python3 fetch_tomtom.py -m $output_dir/modisco_results_allChroms_$score_type.hdf5 -o $output_dir/$score_type.tomtom.tsv -d $meme_db -n 10 -th 0.3
python3 visualize_motif_matches.py -m $output_dir/modisco_results_allChroms_$score_type.hdf5 -t $output_dir/$score_type.tomtom.tsv -o $output_dir \
      -vd $vier_db -th 0.3 -hl http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/$data_type/$cell_type/full_feb15/ -vhl http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/vierstra_logos/ \
      -s $score_type -d /oak/stanford/groups/akundaje/soumyak/motifs/pfms/

#python3 visualize_motif_matches.py -m $output_dir/modisco_results_allChroms_$score_type.hdf5 -t $output_dir/$score_type.tomtom.tsv -o $output_dir \
#      -vd $vier_db -th 0.3 -hl http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/$data_type/$cell_type/chrombppnet_model_encsr283tme_bias/ -vhl http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/vierstra_logos/ \
#      -s $score_type -d /oak/stanford/groups/akundaje/soumyak/motifs/pfms/




