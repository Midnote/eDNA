#!/bin/bash
set -euo pipefail

in_dir="/storage/intern_belief/practice/fasta_results"
JOB_SBATCH="/storage/intern_belief/practice/dereplication.sbatch"

shopt -s nullglob

for input in "$in_dir"/*.fasta; do
  INPUT_BASE="$(basename "$input")"

  sbatch --export=ALL,INPUT_BASE="${INPUT_BASE}" -o "logs/${INPUT_BASE}_%j.log" "$JOB_SBATCH"
done
