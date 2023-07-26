import pandas as pd
import argparse
import numpy as np

NARROWPEAK_SCHEMA = ["chr", "start", "end", "1", "2", "3", "4", "5", "6", "summit"]

def parse_data_args():
    parser=argparse.ArgumentParser(description="filter regions")
    parser.add_argument("-cz", "--chromsizes", type=str, required=True, help="Genome chrom sizes")
    parser.add_argument("-n", "--nonpeaks", type=str, required=True, help="10 column bed file of non-peak regions, centered at summit (10th column)")
    parser.add_argument("-o", "--out", type=str, required=True, help="output file")
    args = parser.parse_args()
    return args




def filter_edge_regions(peaks_df, chrom_to_sizes, width=2114):
    """
    Filter regions in bed file that are on edges i.e regions that cannot be used to construct
    input length + jitter length of the sequence
    """
    input_shape = peaks_df.shape[0]

    # left edge case
    filtered = np.array((peaks_df['start'] + peaks_df['summit'] - width//2) < 0)
    peaks_df = peaks_df[~filtered]
    num_filtered = sum(filtered)

    # right edge case
    filtered = []
    for i, r in peaks_df.iterrows():
        if r['start'] + r['summit'] + width//2 > chrom_to_sizes[r['chr']] :
            filtered.append(True)
        else:
            filtered.append(False)
    filtered=np.array(filtered)
    peaks_df = peaks_df[~filtered]
    num_filtered += sum(filtered)

    print("Number of non peaks input: ",input_shape)
    print("Number of non peaks filtered because the input/output is on the edge: ", num_filtered)
    print("Number of non peaks being used: ",peaks_df.shape[0])

    return peaks_df

if __name__=="__main__":

    args = parse_data_args()
    data_df = pd.read_csv(args.nonpeaks, sep="\t", names=NARROWPEAK_SCHEMA)

    chrom_sizes = {}
    czl = open(args.chromsizes).readlines()
    for line in czl:
        if len(line.strip()) != 0:
            keyl = line.strip().split("\t")[0]
            sizen = int(line.strip().split("\t")[1])
            chrom_sizes[keyl] = sizen

    #print(chrom_sizes)

    fregions = filter_edge_regions(data_df, chrom_sizes)
    fregions.to_csv(args.out, sep="\t", index=False, header=False)






