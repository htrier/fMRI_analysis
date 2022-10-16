# fMRI analysis with FSL and Python

This is a collection of scripts demonstrating how to interface FSL with python and shell commands to conduct fMRI analyses in parallel. Includes examples of how to extract statistics from FSL and plot results.

## Table of contents
* File prep: [scans](#step0_prepare_scans) and [directories](#copy_reg_dir_to_stat_dir.ipynb)
* Create fsf: [Preprocessing](#step3_create_prepro_fsf.ipynb) and [L1 stats](#step4_create_L1stats_fsf.ipynb)
* Parallelize stats: [warping](#run_invwarp_in_parallel.ipynb) and [FEAT](#Run_feat_parallelized_or_sequentially.ipynb)
* Plotting: [whole brain cluster stats](#output_whole_brain_cluster_table.ipynb) and [ROI activations](#Plot_avg_ROI_activations)
