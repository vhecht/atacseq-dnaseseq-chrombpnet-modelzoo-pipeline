arg1=$1
arg2=$2
out=$3
bedtools intersect -v -a $arg1 -b $arg2 > $out


