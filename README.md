# eDNA analysis
Creating ASV and OTU tables from amplicon sequencing data

## Requirements/pre-requisites
To be able to run this project the following things are needed:
1. conda environments with following packages
  1-1) cutadapt
  1-2) vsearch
  1-3) fastQC
  1-4) swarm
2. R with following packages
  2-1) dada2
  2-2) LULU
3. Slurm-managed compute node

## Practical workflow
**1. Move all codes in this repository into a working directory.**
**2.Prepare paired-end sequencing data in a directory named "rawdata", under the working directory.**
**3. Trim adaptors and primers with this command**
```bash
bash array_prep_dada2.sh # "prep_dada2.sbatch" is submitted to slurm node in array mode.
```
**4. Create an ASV table with this command**
```bash
bash array_dada2_pooling.sh # "submit_dada2_pooling.sbatch" is submitted to slurm node to run "dada2_pooling.R"
```
**5. Create a list of OTU sequences with this command**
```bash
sbatch ASV_to_OTU.sbatch
```
**6. Preapre for LULU curation with this command"**
```bash
sbatch submit_OTU_LULU.sbatch # "OTU_LULU.R" is run"
```
**7. Perform LULU curation with this command"**
```bash
sbatch LULU_matchlist.sbatch
```

