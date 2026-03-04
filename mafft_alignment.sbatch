#!/bin/bash
#SBATCH -t 1-00:00:00
#SBATCH -c 4

set -euo pipefail

in_dir="dereplicated"
out_dir="aligned_mafft"
mkdir -p "${out_dir}"

: "${INPUT_BASE:?INPUT_BASE is required (pass via sbatch --export)}"

prefix="dereplicated_extracted_"
SAMPLE="${INPUT_BASE#"$prefix"}"

mafft --op 5 --ep 2 --adjustdirection "${in_dir}/${INPUT_BASE}" > "${out_dir}/mafft_${SAMPLE}"
