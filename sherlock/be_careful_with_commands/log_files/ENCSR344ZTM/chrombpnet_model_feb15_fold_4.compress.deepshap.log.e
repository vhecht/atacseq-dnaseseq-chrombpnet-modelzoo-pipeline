Traceback (most recent call last):
  File "/usr/local/bin/modisco", line 115, in <module>
    pos_patterns, neg_patterns = modiscolite.tfmodisco.TFMoDISco(
  File "/home/users/anusri/.local/lib/python3.8/site-packages/modiscolite/tfmodisco.py", line 281, in TFMoDISco
    seqlet_coords, threshold = extract_seqlets.extract_seqlets(
  File "/home/users/anusri/.local/lib/python3.8/site-packages/modiscolite/extract_seqlets.py", line 161, in extract_seqlets
    pos_threshold = _isotonic_thresholds(pos_values, pos_null_values, 
  File "/home/users/anusri/.local/lib/python3.8/site-packages/modiscolite/extract_seqlets.py", line 117, in _isotonic_thresholds
    model.fit(X, y, sample_weight=sample_weight)
  File "/usr/local/lib/python3.8/site-packages/sklearn/isotonic.py", line 351, in fit
    X, y = self._build_y(X, y, sample_weight)
  File "/usr/local/lib/python3.8/site-packages/sklearn/isotonic.py", line 286, in _build_y
    y = isotonic_regression(
  File "/usr/local/lib/python3.8/site-packages/sklearn/isotonic.py", line 121, in isotonic_regression
    y = check_array(y, ensure_2d=False, input_name="y", dtype=[np.float64, np.float32])
  File "/usr/local/lib/python3.8/site-packages/sklearn/utils/validation.py", line 931, in check_array
    raise ValueError(
ValueError: Found array with 0 sample(s) (shape=(0,)) while a minimum of 1 is required.
Traceback (most recent call last):
  File "compress_deepshap.py", line 148, in <module>
    main()
  File "compress_deepshap.py", line 141, in main
    modisco_check(h5_compressed_reloaded, args.output_prefix, h5_type)
  File "compress_deepshap.py", line 116, in modisco_check
    assert modisco_run.returncode == 0, "Running modisco returned an error"
AssertionError: Running modisco returned an error
