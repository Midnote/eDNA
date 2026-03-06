#!/bin/bash

set -euo pipefail
shopt -s nullglob

in_dir="/storage/intern_belief/practice/rawdata"
JOB="/storage/intern_belief/practice/amplicon_extraction.sbatch"

for r1 in "$in_dir"/*R1*.fastq.gz; do
  r2="${r1/_R1/_R2}"
  [[ -f "$r2" ]] || continue

  R1_BASE="$(basename "$r1")"
  re="^(.*)_R1([^/]*)\.fastq\.gz$"
  if [[ "$R1_BASE" =~ $re ]]; then
    SAMPLE="${BASH_REMATCH[1]}"
  else
    exit 1
  fi

  R1_BASE="$(basename "$r1" .fastq.gz)"
  R2_BASE="$(basename "$r2" .fastq.gz)"

  sbatch --export=ALL,R1_BASE="${R1_BASE}",R2_BASE="${R2_BASE}",SAMPLE="$SAMPLE" \
  -o "logs/${SAMPLE}_%j.log" \
  "$JOB"
done
