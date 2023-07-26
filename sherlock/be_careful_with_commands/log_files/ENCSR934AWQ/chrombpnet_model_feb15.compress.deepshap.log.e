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
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 142, in main
    os.remove(args.input_file)
FileNotFoundError: [Errno 2] No such file or directory: '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR934AWQ/chrombpnet_model_feb15/interpret/full_ENCSR934AWQ.profile_scores.h5'
