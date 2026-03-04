#!/bin/bash
#SBATCH -t 1-00:00:00
#SBATCH -c 4
#SBATCH -p Node3
#SBATCH -e %j.err

set -euo pipefail

in_dir="dereplicated"
out_dir="aligned"
mkdir -p aligned

date
macse -prog alignSequences -seq "${in_dir}/dereplicated_extracted_07-FW01-3_S65_L001.fasta" -gc_def 5
date
