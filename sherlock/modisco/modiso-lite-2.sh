scores_prefix=$1
output_dir=$2
score_type=$3
seqlets=$4
crop=$5
meme_db=$6
vier_db=$7
cell_type=$8
data_type=$9
regions=${10}

genome=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa


if [[ -f $output_dir/$cell_type.modisco.$score_type.h5 ]] ; then
    echo "python convert_new_to_old.py --input $output_dir/$cell_type.modisco.$score_type.h5 --output $output_dir/modisco_results_allChroms_$score_type.hdf5"
    python convert_new_to_old.py --input $output_dir/$cell_type.modisco.$score_type.h5 --output $output_dir/modisco_results_allChroms_$score_type.hdf5
fi
wait

echo "modisco report -i $output_dir/$cell_type.modisco.$score_type.h5 -o  $output_dir/$score_type/ -s http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/$data_type/$cell_type/full_feb15_compressed/$score_type/ -m /oak/stanford/groups/akundaje/soumyak/motifs/motifs.meme.txt"
export PATH=$PATH:/home/groups/akundaje/annashch/miniconda3/bin/
modisco report -i $output_dir/$cell_type.modisco.$score_type.h5 -o  $output_dir/$score_type/  -s http://mitra.stanford.edu/kundaje/oak/projects/chromatin-atlas-2022/modisco/$data_type/$cell_type/full_feb15_compressed/$score_type/ -m /oak/stanford/groups/akundaje/soumyak/motifs/motifs.meme.txt

#rm $output_dir/$cell_type"_temp_"$score_type"_scores.h5"
#wait



