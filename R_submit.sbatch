#!/bin/bash

#SBATCH --job-name="Rscript"
#SBATCH --partition="Node3"
#SBATCH --time=1:00:00
#SBATCH --mem=4GB

/home/intern_CY/miniforge3/envs/dada2/bin/Rscript --no-save --no-restore OTU_for_LULU.R

