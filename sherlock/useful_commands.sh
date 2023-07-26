#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime" | grep "RUNNING"  | grep "modelling"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime" | grep "PENDING"  | grep "modelling"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "modelling"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime" | grep "PENDING"  | grep "modelling"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime" | grep "COMPLETED"  | grep "modelling"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "preprocessing2" | grep "RUNNING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "gc_matching2" | grep "RUNNING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "preprocessing3" | grep "RUNNING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "preprocessing"  | grep "COMPLETED"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "interpret" | grep "PENDING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "modisco" | grep "COMPLETED"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "interpret" | grep "RUNNING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "peak_calling" | grep "RUNNING"
#sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime"  | grep "RUNNING"
sacct --format="JobID,JobName%30,Partition,Account,AllocCPUS,State,ExitCode,CPUTime" 


#7455641

#squeue --me -h -o "%i" -u anusri | xargs scancel





