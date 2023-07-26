Traceback (most recent call last):
  File "/usr/local/bin/modisco", line 92, in <module>
    sequences = np.load(args.sequences)
  File "/usr/local/lib/python3.8/site-packages/numpy/lib/npyio.py", line 405, in load
    fid = stack.enter_context(open(os_fspath(file), "rb"))
FileNotFoundError: [Errno 2] No such file or directory: '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR477YSU/chrombpnet_model_feb15_fold_2/interpret/full_ENCSR477YSU.counts_scores_test_modisco_seqs.npy'
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 141, in main
    modisco_check(h5_compressed_reloaded, args.output_prefix, h5_type)
  File "compress_deepshap.py", line 116, in modisco_check
    assert modisco_run.returncode == 0, "Running modisco returned an error"
AssertionError: Running modisco returned an error
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 142, in main
    os.remove(args.input_file)
FileNotFoundError: [Errno 2] No such file or directory: '/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/ENCSR477YSU/chrombpnet_model_feb15_fold_2/interpret/full_ENCSR477YSU.profile_scores.h5'
