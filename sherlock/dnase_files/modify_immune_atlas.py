
data = open("immuneatlas_files.txt")
encode_acceess=[]
for line in data:
	if "EN" in line.strip():
		encode_acceess.extend([val.strip() for val in line.strip().split(";")])

f = open("immuneatlas_new_files.txt", "w")
for val in encode_acceess:
	f.write(val+"\n")	
