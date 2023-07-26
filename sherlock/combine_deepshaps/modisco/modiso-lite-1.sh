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

echo "python make_temp_h5.py -s $scores_prefix -p $score_type -o  $output_dir/$cell_type -r $regions -g $genome"
python make_temp_h5.py -s $scores_prefix -p $score_type -o  $output_dir/$cell_type -r $regions -g $genome




