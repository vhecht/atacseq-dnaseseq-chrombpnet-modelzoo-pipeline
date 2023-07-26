

def parse_args():
        parser = argparse.ArgumentParser(description="Compresses h5 file with SHAP scores and replaces the original file")
        parser.add_argument("-i", "--input_dir", type=str, required=True, help="")
        parser.add_argument("-if", "--input_file", type=list, required=True, help="")
        parser.add_argument("-o", "--output_file", type=list, required=True, help="")
        args = parser.parse_args()
        return arg


