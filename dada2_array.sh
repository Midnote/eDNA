#!/bin/bash

file_dir="/storage/intern_belief/practice/dada2raw"
filelist="/storage/intern_belief/practice/R1_filelist.txt"

ls -1 "$file_dir"/*R1_001.fastq.gz > "$filelist"

N=$(wc -l < "$filelist")
sbatch --array=1-"$N"%5 dada2_submit.sbatch
