Killed
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 125, in main
    h5_type_test = h5py.File(args.input_file, "r")
  File "/usr/local/lib/python3.8/site-packages/h5py/_hl/files.py", line 567, in __init__
    fid = make_fid(name, mode, userblock_size, fapl, fcpl, swmr=swmr)
  File "/usr/local/lib/python3.8/site-packages/h5py/_hl/files.py", line 231, in make_fid
    fid = h5f.open(name, flags, fapl=fapl)
  File "h5py/_objects.pyx", line 54, in h5py._objects.with_phil.wrapper
  File "h5py/_objects.pyx", line 55, in h5py._objects.with_phil.wrapper
  File "h5py/h5f.pyx", line 106, in h5py.h5f.open
OSError: Unable to open file (file signature not found)
slurmstepd: error: Detected 1 oom-kill event(s) in StepId=14765404.batch. Some of your processes may have been killed by the cgroup out-of-memory handler.
