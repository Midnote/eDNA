# eDNA metabarcoding

Slurm and R scripts for processing paired-end Illumina reads from environmental DNA samples. The project targets an approximately 313 bp region of mitochondrial cytochrome c oxidase subunit I (COI) and builds amplicon sequence variant (ASV) and operational taxonomic unit (OTU) tables for comparing communities across samples.

## Analysis paths

| Path | Stages | Outputs |
| --- | --- | --- |
| ASV and OTU analysis | [Trim paired reads and infer ASVs with DADA2](dada2/) → [cluster with Swarm and build a BLAST+ match list](OTU/) | ASV table and FASTA, OTU table and representative sequences, and a match list for LULU |
| Merged read inspection and alignment | [Extract merged amplicons](trimming/) → [convert reads to FASTA](alignment/fastq_to_fasta.sh) → [dereplicate](dereplication_submit.sh) → [align with MAFFT and refine with MACSE](alignment/) | Extracted reads and sequence alignments for inspection |

See the [workflow guide](docs/workflow.md) for the script entry points, inputs and outputs, and checks to make before submitting jobs.

## Requirements

- Bash and a Slurm-managed Linux cluster.
- Cutadapt and R with DADA2 for the ASV stage, then Swarm and NCBI BLAST+ for OTU clustering and match-list generation.
- VSEARCH, seqtk, MAFFT and MACSE for the merged-read and alignment path. FastQC is useful for inspecting read quality.
- Paired-end gzipped FASTQ input. The DADA2 jobs expect `_R1_001.fastq.gz` and `_R2_001.fastq.gz` suffixes.

## Project status

The scripts were written for a specific Slurm installation. Review the [cluster setup and path assumptions](docs/workflow.md#before-submitting-jobs) before running them. The checked-in workflow reaches OTU match-list generation. LULU curation and taxonomic assignment are downstream analysis steps.
