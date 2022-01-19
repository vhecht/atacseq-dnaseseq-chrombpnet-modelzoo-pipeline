tag=$1

pval_thresh = 0.01
NPEAKS=200000 # capping number of peaks called from MACS2
smooth_window=150 # default
shiftsize=$(( -$smooth_window/2 ))
gensz=
prefix=
peakfile="$prefix.narrowPeak.gz"

macs2 callpeak \
    -t $tag -f BED -n $prefix -g $gensz -p $pval_thresh \
   --shift $shiftsize  --extsize $smooth_window --nomodel --keep-dup all --call-summits

# Sort by Col8 in descending order and replace long peak names in Column 4 with Peak_<peakRank>
sort -k 8gr,8gr "$prefix"_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n ${NPEAKS} | gzip -nc > $peakfile

