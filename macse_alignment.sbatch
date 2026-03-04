#!/bin/bash
#SBATCH -t 1-00:00:00
#SBATCH -c 4
#SBATCH -p Node3
#SBATCH -e errors/%j.err

set -euo pipefail

in_dir="aligned_mafft"
out_dir="aligned_macse"

mkdir -p "${out_dir}"

: "${INPUT_BASE:?INPUT_BASE is required (pass via sbatch --export)}"

date
macse -prog refineAlignment \
-align "${in_dir}/${INPUT_BASE}" \
-out_NT "${out_dir}/macse_NT_${INPUT_BASE}" \
-out_AA "${out_dir}/macse_AA_${INPUT_BASE}" \
-gc_def 5
date
