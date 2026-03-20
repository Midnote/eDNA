#!/bin/bash
#SBATCH --job-name="LULU_matchlist"
#SBATCH --cpus-per-task=4
#SBATCH --mem=4GB
#SBATCH --time=24:00:00
#SBATCH --partition=Node3

cd ../OTU_results

makeblastdb -in OTU_sequences.fasta -parse_seqids -dbtype nucl

blastn -db OTU_sequences.fasta -outfmt '6 qseqid sseqid pident' \
-out match_list.txt -qcov_hsp_perc 80 -perc_identity 84 \
-query OTU_sequences.fasta
