import argparse
import deepdish
import os
import pandas as pd
import deepdish as dd
import numpy as np
def parse_args():
        parser = argparse.ArgumentParser(description="Compresses h5 file with SHAP scores and replaces the original file")
        parser.add_argument("-i", "--input_dir", type=str, required=True, help="")
        parser.add_argument("-if", "--input_file", type=str, nargs='+', required=True, help="")
        parser.add_argument("-e", "--experiment", type=str, required=True, help="")
        parser.add_argument("-o", "--output_file", type=str, required=True, help="")
        parser.add_argument("-t", "--type", type=str, required=True, help="")
        args = parser.parse_args()

        return args

def main(args):

        interpretation_files = []
        bed_files = []
        order = []
        for filer in args.input_file:
                interpret_f = os.path.join(args.input_dir,os.path.join(filer,"interpret/full_"+args.experiment+"."+args.type+"_scores_compressed.h5"))
                if os.path.isfile(interpret_f):
                        interpretation_files.append(interpret_f)
                else:
                        print("not found")
                        print(interpret_f)
                bed_file = os.path.join(args.input_dir,os.path.join(filer,"interpret/full_"+args.experiment+".interpreted_regions_"+args.type+".bed"))
                if os.path.isfile(bed_file):
                        bed_files.append(bed_file)
                else:
                        bed_file = os.path.join(args.input_dir,os.path.join(filer,"interpret/full_"+args.experiment+".interpreted_regions.bed"))
                        if os.path.isfile(bed_file):
                            bed_files.append(bed_file)


        assert(len(interpretation_files)==5)
        assert(len(bed_files)==5)
        bed_files.reverse()
        interpretation_files.reverse()
        idx = 0
        set_flag = False
        for bed_file in bed_files:
                print(bed_file)
                if idx==0:
                        main_bed = pd.read_csv(bed_file,sep="\t", header=None)
                else:
                        bed  = pd.read_csv(bed_file,sep="\t", header=None)
                        if idx != 4:                            
                            assert(main_bed.equals(bed))
                        else:
                           if not main_bed.equals(bed):
                               set_flag=True
                               assert(bed.shape[0]>=main_bed.shape[0])
                               main_bed["index"] = main_bed[0]+"_"+main_bed[1].astype(str)+"_"+main_bed[2].astype(str)+"_"+main_bed[3].astype(str)+"_"+main_bed[9].astype(str)
                               bed["index"] = bed[0]+"_"+bed[1].astype(str)+"_"+bed[2].astype(str)+"_"+bed[3].astype(str)+"_"+bed[9].astype(str)
                               test_rsids = bed["index"].values
                               rsids = main_bed["index"].values
                               order = []
                               bed_shape = bed.shape[0]
                               for rsid in rsids:
                                    pidx = np.where(test_rsids==rsid)
                                    assert(len(pidx[0])!= 0)
                                    order.append(pidx[0][0])                                
                idx+=1

        idx = 0
        for interpret_f in interpretation_files:
                print(interpret_f)
                data = dd.io.load(interpret_f)["shap"]["seq"]   
                if idx==0:
                        new_d = data
                else:
                        if idx != 4:
                            assert(new_d.shape==data.shape)
                            assert(new_d.shape[0]==main_bed.shape[0])
                            new_d = new_d + data
                        else:
                            if set_flag:
                                assert(new_d.shape[0]==len(order))
                                jdx = 0
                                assert(data.shape[0]==bed_shape)
                                for od in order:
                                    new_d[jdx] = new_d[jdx] + data[od]
                                    jdx += 1
                            else:
                                assert(new_d.shape==data.shape)
                                assert(new_d.shape[0]==main_bed.shape[0])
                                new_d = new_d + data
                        #print(data[0][0][0])
                del data
                #print(new_d.shape)
                #print(bed.shape)
                #print(new_d[0][0][0])
                idx += 1

        new_d = new_d / 5
        #print(new_d[0][0][0])

        chroms = open("chroms_accept.txt").readlines()
        chroms = [chrom.strip() for chrom in chroms]
        print(chroms)
        print("peaks shape", main_bed.shape)
        index = main_bed[0].isin(chroms)
        sub_bed = main_bed[index]
        new_d_sub = new_d[index]
        assert(sub_bed.shape[0]==new_d_sub.shape[0])
        print("peaks shape after removing chrM and random chroms", sub_bed.shape)
        print("peaks shape with chrM and random chroms", sum(~main_bed[0].isin(chroms)))
        
        new_data = {}
        new_data["shap"] = {}
        new_data["shap"]["seq"] = new_d_sub
        print(new_data["shap"]["seq"].shape)
        print(sub_bed.shape)
        f = open("{}.{}.order.txt".format(args.output_file,args.type), "w")
        for line in order:
            f.write(str(line))
            f.write("\n")
        f.close()
        if set_flag:
            sub_bed = sub_bed.drop(columns=['index'])
        dd.io.save("{}.mean_shap.".format(args.output_file)+args.type+"_scores_compressed.h5", new_data, compression='blosc')
        sub_bed.to_csv("{}.interpreted_{}.bed".format(args.output_file,args.type), sep="\t", header=False, index=False)

if __name__=="__main__":
        args = parse_args()
        main(args)
