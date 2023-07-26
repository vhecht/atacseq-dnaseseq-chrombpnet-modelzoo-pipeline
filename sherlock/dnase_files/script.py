data = open("immuneatlas_files_v2.txt").readlines()
data_old = [id.strip() for id in open("immuneatlas_new_files.txt").readlines()]
new_data=[]
for line in data:
	ids = line.strip().split(";")
	for id in ids:
		id = id.strip()
		if "ENCS" in id:
			if id not in data_old:
				if id not in new_data:
					new_data.append(id)		

lines = "\n".join(new_data)
f = open("immuneatlas_files_v2_new.txt", "w")
f.write(lines)
f.close()
