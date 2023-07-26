bw1=$1
bw2=$2
bw3=$3
bw4=$4
bw5=$5
output=$6

echo singularity exec /home/groups/akundaje/anusri/simg/wiggletools/wiggletools_latest.sif wiggletools mean $bw1 $bw2 $bw3 $bw4 $bw5 $output".wig"

singularity exec /home/groups/akundaje/anusri/simg/wiggletools/wiggletools_latest.sif wiggletools mean $bw1 $bw2 $bw3 $bw4 $bw5 $output".wig"

wait

eval "$(conda shell.bash hook)"
conda activate /home/groups/akundaje/anusri/simg/ucsc

wigToBigWig $output".wig" /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/chrom.sizes $output

wait

rm $output".wig"
