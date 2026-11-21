# COI metabarcoding workflow

This guide maps the Slurm and R scripts to the two analysis paths used for environmental COI metabarcoding. The input is paired-end Illumina FASTQ data targeting an approximately 313 bp fragment of mitochondrial COI. Use the script links below to inspect the settings for each stage.

## ASV and OTU analysis

DADA2 takes paired reads. Its preparation step trims adapters and primers while keeping the R1 and R2 files separate. DADA2 filters the reads, learns error rates, infers variants, merges pairs and removes chimeras. Swarm then clusters ASVs, and BLAST+ builds the sequence match list used for post-clustering curation.

| Stage | Scripts | Input → output |
| --- | --- | --- |
| Prepare paired reads | [Array launcher](../dada2/array_prep_dada2.sh) and [Cutadapt job](../dada2/prep_dada2.sbatch) | Paired reads in `rawdata/` → trimmed pairs in `dada2raw/` |
| Generate an ASV table | [DADA2 job](../dada2/submit_dada2_pooling.sbatch) and [R script](../dada2/dada2_pooling.R) | Trimmed pairs → `ASV_table.csv` and `pooled.fasta` |
| Inspect individual samples | [Per-sample launcher](../dada2/array_dada2_amplicon.sh), [job](../dada2/submit_dada2_amplicon.sbatch) and [R script](../dada2/dada2_amplicon.R) | One trimmed pair per task → one ASV FASTA per sample |
| Cluster ASVs | [Swarm job](../OTU/ASV_to_OTU.sbatch) | `pooled.fasta` → `OTU_results/swarm_log.txt` |
| Assemble OTU counts | [OTU table script](../OTU/OTU_LULU.R) | ASV table and Swarm clusters → `OTU_table.csv` and `OTU_sequences.fasta` |
| Build a match list | [BLAST+ job](../OTU/LULU_matchlist.sbatch) | `OTU_sequences.fasta` → `match_list.txt` |

The ASV table has samples as rows and ASV sequences as columns. The OTU table has OTUs as rows and samples as columns. The current scripts build the OTU table and match list. Applying LULU curation and assigning taxonomy are follow-on analysis steps.

### Before submitting jobs

- Use Bash on a Slurm cluster and provide paired files ending in `_R1_001.fastq.gz` and `_R2_001.fastq.gz`. The DADA2 scripts take the sample label from the second underscore-separated field. Check that retained labels are unique and that sorted R1 and R2 lists correspond.
- Review the scripts' cluster-specific paths, Conda activation, partitions and log directories. Slurm resolves relative data paths from the job's working directory. For the DADA2 and OTU scripts, the relative paths generally assume stage directories with the data directories one level above. Create required log and intermediate directories before submission.
- Reconcile the two different paths to `trimmed/` in [the preparation job](../dada2/prep_dada2.sbatch) and the `asv_results/` versus `ASV_results/` spelling across the DADA2 and OTU scripts before running on Linux.
- Run [the multi-sample DADA2 job](../dada2/submit_dada2_pooling.sbatch) once after preparation completes. [The old array launcher](../dada2/array_dada2_pooling.sh) submits a task per raw R1 file even though each task processes all samples and writes the same outputs. The R script learns errors across the input set and leaves DADA2's inference pooling option at its default.
- [The OTU submission wrapper](../OTU/submit_OTU_LULU.sbatch) refers to an earlier filename. Use the tracked `OTU_LULU.R` from the `OTU/` directory once its expected inputs are in place. It uses the `sq` indices from the Swarm output to look up ASV counts. Keep the ASV FASTA and table from the same run.

## Merged read inspection and alignment

This separate route uses Cutadapt to trim adapters, VSEARCH to merge read pairs, and Cutadapt to remove linked primers from the merged reads. Use it to inspect the extracted COI reads and prepare alignments.

| Stage | Files |
| --- | --- |
| Extract merged amplicons | [Trimming launcher](../trimming/submit_amplicon_extraction.sh) and [extraction job](../trimming/amplicon_extraction.sbatch) write extracted FASTQ files under `results/`. |
| Convert to FASTA and dereplicate | [FASTQ conversion](../alignment/fastq_to_fasta.sh), [dereplication launcher](../dereplication_submit.sh) and [VSEARCH job](../dereplication.sbatch). The converter writes plain FASTA with a `.fasta.gz` suffix, while the launcher looks for `.fasta`. Check file contents and extensions before submission. |
| Align or refine | [MAFFT launcher](../alignment/mafft_submit.sh) and [job](../alignment/mafft_alignment.sbatch) produce alignments that can be refined with [the MACSE launcher](../alignment/macse_submit.sh) and [job](../alignment/macse_alignment.sbatch). |

The merged reads are useful for read-quality and length checks. For the ASV workflow, start from paired FASTQ files so DADA2 can denoise the mates before merging them.
