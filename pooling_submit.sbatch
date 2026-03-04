#!/bin/bash

#SBATCH --job-name="dada2"
#SBATCH --partition="Node3"
#SBATCH --output="logs/dada2-%j.out"
#SBATCH --error="errors/dada2-%j.err"
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00

source "/home/intern_CY/miniforge3/etc/profile.d/conda.sh"
conda activate dada2

Rscript --no-save --no-restore dada2_pooling.R

