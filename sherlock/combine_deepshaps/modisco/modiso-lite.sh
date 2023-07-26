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

genome=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa

echo "modisco motifs -v -i $output_dir/$cell_type"_temp_"$score_type"_scores.h5" -n $seqlets -o $output_dir/$cell_type.modisco.$score_type.h5 -w 500"
modisco motifs -v -i $output_dir/$cell_type"_temp_"$score_type"_scores.h5" -n $seqlets -o $output_dir/$cell_type.modisco.$score_type.h5 -w 500


