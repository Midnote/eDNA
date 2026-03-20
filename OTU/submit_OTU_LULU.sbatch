#!/bin/bash

#SBATCH --job-name="Rscript"
#SBATCH --partition="Node3"
#SBATCH --time=1:00:00
#SBATCH --mem=4GB

Rscript --no-save --no-restore OTU_for_LULU.R