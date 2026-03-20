#!/bin/bash

file_dir="/storage/intern_belief/practice/rawdata" 
filelist="/storage/intern_belief/practice/raw_filelist.txt"

ls -1 "$file_dir"/*R1_001.fastq.gz > "$filelist"
N=$(wc -l < "$filelist")

source "/home/intern_CY/miniforge3/etc/profile.d/conda.sh"
conda activate cutadapt

mkdir -p "../ASV_results"

sbatch --array=1-"$N"%5 submit_dada2_pooling.sbatch
