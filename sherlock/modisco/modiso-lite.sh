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

echo "modisco motifs -i $output_dir/$cell_type"_temp_"$score_type"_scores.h5" -n $seqlets -o $output_dir/$cell_type.modisco.$score_type.h5 -w 500"
modisco motifs -i $output_dir/$cell_type"_temp_"$score_type"_scores.h5" -n $seqlets -o $output_dir/$cell_type.modisco.$score_type.h5 -w 500


