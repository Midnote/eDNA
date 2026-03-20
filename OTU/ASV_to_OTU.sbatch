#!/bin/bash
#SBATCH --job-name="ASV_to_OTU"
#SBATCH --cpus-per-task=4
#SBATCH --mem=4GB
#SBATCH --time=24:00:00
#SBATCH --partition=Node3

mkdir -p "../OTU_results"

ASV_FASTA="../ASV_results/pooled.fasta"
SWARMS_TXT="../OTU_results/swarm_log.txt"

swarm --usearch-abundance --difference 1 --fastidious \
--output-file "${SWARMS_TXT}" "${ASV_FASTA}"
