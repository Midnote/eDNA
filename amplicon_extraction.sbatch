#!/bin/bash
#SBATCH -J amplicon_extract
#SBATCH -t 1-00:00:00
#SBATCH -c 4
#SBATCH -p Node3

set -euo pipefail # immediately terminate job when error

: "${R1_BASE:?R1_BASE is required (pass via sbatch --export)}"
: "${R2_BASE:?R2_BASE is required (pass via sbatch --export)}"
: "${SAMPLE:?SAMPLE is required (pass via sbatch --export)}"

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAX \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTX \
--no-indels \
-O 20 \
-o "trimmed/trim-${R1_BASE}.fastq" \
-p "trimmed/trim-${R2_BASE}.fastq" \
"rawdata/${R1_BASE}.fastq.gz" "rawdata/${R2_BASE}.fastq.gz"

vsearch --fastq_mergepairs "trimmed/trim-${R1_BASE}.fastq" \
--reverse "trimmed/trim-${R2_BASE}.fastq" \
--fastq_minmergelen 350 \
--fastq_maxmergelen 371 \
--fastq_minovlen 200 \
--fastqout "merged/merged-${SAMPLE}.fastq"

cutadapt -a XGGWACWGGWTGAACWGTWTAYCCYCC...TGRTTYTTYGGHCAYCCHGARGTHTAX \
-a XTADACYTCDGGRTGDCCRAARAAYCA...GGRGGRTAWACWGTTCAWCCWGTWCCX \
--match-read-wildcards \
-O 15 --no-indels \
--times 2 \
--discard-untrimmed \
-o "results/extracted_${SAMPLE}.fastq.gz" \
"merged/merged-${SAMPLE}.fastq"
