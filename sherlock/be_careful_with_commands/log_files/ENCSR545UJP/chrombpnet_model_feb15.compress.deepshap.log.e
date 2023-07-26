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

Unable to open/create file '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR545UJP/chrombpnet_model_feb15/interpret/full_ENCSR545UJP.profile_scores_compressed.h5'
Traceback (most recent call last):
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 480, in _load_level
    return pathtable[pathname]
KeyError: '/'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 480, in _load_level
    return pathtable[pathname]
KeyError: '/projected_shap'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 480, in _load_level
    return pathtable[pathname]
KeyError: '/projected_shap/seq'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 135, in main
    h5_compressed_reloaded = dd.io.load(args.output_prefix + "_compressed.h5")
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 663, in load
    data = _load_level(h5file, grp, pathtable)
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 482, in _load_level
    pathtable[pathname] = _load_nonlink_level(handler, node, pathtable,
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 371, in _load_nonlink_level
    lev = _load_level(handler, grp, pathtable)
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 482, in _load_level
    pathtable[pathname] = _load_nonlink_level(handler, node, pathtable,
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 371, in _load_nonlink_level
    lev = _load_level(handler, grp, pathtable)
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 482, in _load_level
    pathtable[pathname] = _load_nonlink_level(handler, node, pathtable,
  File "/usr/local/lib/python3.8/site-packages/deepdish/io/hdf5io.py", line 463, in _load_nonlink_level
    return level[:]
  File "/usr/local/lib/python3.8/site-packages/tables/array.py", line 625, in __getitem__
    arr = self._read_slice(startl, stopl, stepl, shape)
  File "/usr/local/lib/python3.8/site-packages/tables/array.py", line 729, in _read_slice
    self._g_read_slice(startl, stopl, stepl, nparr)
  File "tables/hdf5extension.pyx", line 1583, in tables.hdf5extension.Array._g_read_slice
tables.exceptions.HDF5ExtError: HDF5 error back trace

  File "H5Dio.c", line 179, in H5Dread
    can't read data
  File "H5VLcallback.c", line 2011, in H5VL_dataset_read
    dataset read failed
  File "H5VLcallback.c", line 1978, in H5VL__dataset_read
    dataset read failed
  File "H5VLnative_dataset.c", line 166, in H5VL__native_dataset_read
    can't read data
  File "H5Dio.c", line 545, in H5D__read
    can't read data
  File "H5Dchunk.c", line 2569, in H5D__chunk_read
    unable to read raw data chunk
  File "H5Dchunk.c", line 3939, in H5D__chunk_lock
    data pipeline read failed
  File "H5Z.c", line 1390, in H5Z_pipeline
    filter returned failure during read
  File "hdf5-blosc/src/blosc_filter.c", line 245, in blosc_filter
    Blosc decompression error

End of HDF5 error back trace

Problems reading the array data.
