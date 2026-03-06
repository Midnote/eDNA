#!/bin/bash
#SBATCH -J amplicon_extract
#SBATCH -t 1-00:00:00
#SBATCH -c 4
#SBATCH -p Node3
#SBATCH -o "logs/%j.log"

filelist="/storage/intern_belief/practice/raw_filelist.txt"
R1_FILE="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$filelist")"

R1_BASE="$(basename "${R1_FILE}")"
R2_BASE="${R1_BASE/_R1/_R2}"

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAX \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTX \
--no-indels --revcomp \
-O 20 \
-o "trimmed/trim-${R1_BASE}" \
-p "trimmed/trim-${R2_BASE}" \
"rawdata/${R1_BASE}" "rawdata/${R2_BASE}"

cutadapt -g XGGWACWGGWTGAACWGTWTAYCCYCC \
-G XTADACYTCDGGRTGDCCRAARAAYCA \
--match-read-wildcards \
--revcomp \
-O 15 --no-indels \
--discard-untrimmed \
-o "dada2raw/dada2raw_${R1_BASE}" \
-p "dada2raw/dada2raw_${R2_BASE}" \
"trimmed/trim-${R1_BASE}" "trimmed/trim-${R2_BASE}"
