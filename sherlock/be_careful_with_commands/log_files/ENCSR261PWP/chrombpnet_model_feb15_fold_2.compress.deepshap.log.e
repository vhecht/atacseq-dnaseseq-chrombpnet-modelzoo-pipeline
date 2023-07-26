Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 134, in main
    compress_scores(h5_orig, h5_type, args.output_prefix)
  File "compress_deepshap.py", line 36, in compress_scores
    dd.io.save(output_prefix + "_compressed.h5", h5_compressed, compression="blosc")
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 574, in save
    with tables.open_file(path, mode='w') as h5file:
  File "/usr/local/lib/python3.8/site-packages/tables/file.py", line 300, in open_file
    return File(filename, mode, title, root_uep, filters, **kwargs)
  File "/usr/local/lib/python3.8/site-packages/tables/file.py", line 750, in __init__
    self._g_new(filename, mode, **params)
  File "tables/hdf5extension.pyx", line 484, in tables.hdf5extension.File._g_new
tables.exceptions.HDF5ExtError: HDF5 error back trace

  File "H5F.c", line 532, in H5Fcreate
    unable to create file
  File "H5VLcallback.c", line 3282, in H5VL_file_create
    file create failed
  File "H5VLcallback.c", line 3248, in H5VL__file_create
    file create failed
  File "H5VLnative_file.c", line 63, in H5VL__native_file_create
    unable to create file
  File "H5Fint.c", line 1898, in H5F_open
    unable to lock the file
  File "H5FD.c", line 1625, in H5FD_lock
    driver lock request failed
  File "H5FDsec2.c", line 1002, in H5FD__sec2_lock
    unable to lock file, errno = 11, error message = 'Resource temporarily unavailable'

End of HDF5 error back trace

Unable to open/create file '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR261PWP/chrombpnet_model_feb15_fold_2/interpret/full_ENCSR261PWP.counts_scores_compressed.h5'
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 140, in main
    quality_check(h5_compressed_reloaded, h5_orig, h5_type)
  File "compress_deepshap.py", line 88, in quality_check
    assert np.corrcoef(comp_flat, orig_flat)[0,1] > 0.98, "Compressed file is not sufficiently similar to the original file"
AssertionError: Compressed file is not sufficiently similar to the original file
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 142, in main
    os.remove(args.input_file)
FileNotFoundError: [Errno 2] No such file or directory: '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR261PWP/chrombpnet_model_feb15_fold_2/interpret/full_ENCSR261PWP.profile_scores.h5'
