#!/bin/bash
#SBATCH -J dereplication
#SBATCH -t 01:00:00
#SBATCH -c 4
#SBATCH -p Node3

set -euo pipefail

in_dir="fasta_results"
out_dir="dereplicated"
mkdir -p dereplicated

: "${INPUT_BASE:?INPUT_BASE is required (pass via sbatch --export)}"

vsearch --derep_fulllength "${in_dir}/${INPUT_BASE}" \
--output "${out_dir}/dereplicated_${INPUT_BASE}" \
--sizeout

