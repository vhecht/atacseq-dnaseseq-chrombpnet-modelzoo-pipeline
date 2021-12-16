import pyfaidx
import numpy as np
import pyBigWig
import viz_sequence
import matplotlib.pyplot as plt
from scipy.spatial import distance
import argparse
import one_hot
import json

def parse_args():
    parser=argparse.ArgumentParser(description="build pwm matrix from bigwig")
    parser.add_argument("-i","--bigwig", required=True,  help="generated bigiwig file")
    parser.add_argument("-g", "--genome", required=True, help="reference genome fasta")
    parser.add_argument("-o", "--output_prefix", required=True,  help="output dir for storing pwm")
    parser.add_argument("-c","--chr",type=str, required=True, help="chromosome to build pwm, the name should be present in the chrom sizes file and bigwig you will provide")
    parser.add_argument("-cz","--chrom_sizes",type=str, required=True, help="TSV file with chromosome name in first column and size in the second column")
    parser.add_argument("-pw","--pwm_width",type=int, default=24, required=False, help="width of pwm matrix")
    parser.add_argument("-pg","--pwm_gt",type=str, required=False, help="Json file with an array containing the tn5/DNAS-I motif pwm for comparison ")
    return parser.parse_args()

def get_pwm_bg(seqs, cnts, pwm_width=24):
    '''
    Arguments::
        seqs: An input array of shape L x alphabet
        cnts: An input array of shape L
    
    Returns:
        motif: PPM (Position Probability Matrix) dimensions of length x alphabet.
               Entries along the alphabet axis sum to 1.
        bg: The background base frequencies
    '''
    new_seqs = []
    for i in range(pwm_width//2,cnts.shape[0]-pwm_width//2):
        if cnts[i] > 0:
            new_seqs.append(seqs[i-pwm_width//2:i+pwm_width//2,:]*cnts[i])
    motif = np.sum(new_seqs, axis=0)
    motif = motif/np.sum(motif, axis=-1, keepdims=True)
    bg = np.sum(np.sum(new_seqs, axis=0), axis=0)
    bg = bg/sum(bg)
    return motif, bg

if __name__=="__main__":

    args = parse_args()

    assert(args.pwm_width % 2 ==0)

    # access files
    hg38 = pyfaidx.Fasta(args.genome)
    bw = pyBigWig.open(args.bigwig) 

    ## find given chromosome size

    chrom_sizes_dict = {line.strip().split("\t")[0]:int(line.strip().split("\t")[1]) for line in open(args.chrom_sizes).readlines()}
    chr_size = chrom_sizes_dict[args.chr]

    # fetch values in the given chromsome and for the given chromsome region
    seq = str(hg38[args.chr][0:chr_size])
    one_hot_seq = one_hot.dna_to_one_hot(seq).squeeze()
    bigwig_vals = np.nan_to_num(bw.values(args.chr,0,chr_size ))
    print("non zero bigwig entries in the given chromosome: ", np.sum(bigwig_vals>0))

    # build pwm matrix - get PPM and background
    motif, bg = get_pwm_bg(one_hot_seq, bigwig_vals, args.pwm_width)

    # use modisco utils to plot the obtained motif
    curr_data_motif = viz_sequence.ic_scale(motif, background=bg)
    figsize=(20,2)
    fig = plt.figure(figsize=figsize)
    ax = fig.add_subplot(111) 
    viz_sequence.plot_weights_given_ax(ax=ax, array=curr_data_motif)
    plt.savefig(args.output_prefix)

    ## compare current motif to the given ground truth motif for similarity check
    if args.pwm_gt is not None:
        tn5_motif = np.array(json.load(open(args.pwm_gt)))
        assert(curr_data_motif.shape[0] == tn5_motif.shape[0])
        assert(curr_data_motif.shape[1] == tn5_motif.shape[1])

        similarity_per_position = []
        motif_string = ""
        bases = np.array(["A", "C", "G", "T", "N"])
        for i in range(tn5_motif.shape[0]):
            similarity_per_position.append(distance.cosine(curr_data_motif[i,:],tn5_motif[i,:]))
            motif_string += bases[np.argmax(curr_data_motif[i,:])]
            

        similarity_score = np.mean(similarity_per_position)
        if  similarity_score < 0.35:
            output_string = "correct_shift_"+str(np.round(similarity_score,2))+"_"+motif_string
        else:
            output_string = "incorrect_shift_"+str(np.round(similarity_score,2))+"_"+motif_string

        ofile = open(args.output_prefix+".score.txt","w")
        ofile.write(output_string)
        ofile.close()




