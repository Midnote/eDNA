library(dada2)

work_dir <- "/storage/intern_belief/practice"

args <- commandArgs(trailingOnly = TRUE)
R1_FILE <- args[1]

fnFs <- R1_FILE
fnRs <- gsub("_R1", "_R2", R1_FILE)
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 2)

filtFs <- file.path(work_dir, "filtered_dada2", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(work_dir, "filtered_dada2", paste0(sample.names, "_R_filt.fastq.gz"))

temp_out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, maxN=0, compress=TRUE, multithread=TRUE)
head(temp_out)

errF <- learnErrors(filtFs, randomize=TRUE, multithread=TRUE)
errR <- learnErrors(filtRs, randomize=TRUE, multithread=TRUE)

derepFs <- derepFastq(filtFs)
derepRs	<- derepFastq(filtRs)

names(derepFs) <- sample.names
names(derepRs) <- sample.names

dadaFs <- dada(derepFs, err=errF, multithread=TRUE)
dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, minOverlap=200)

mergers[[1]]

seqtab <- makeSequenceTable(mergers)
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)

print(seqtab)
print(seqtab.nochim)

results <- file.path(work_dir, "asv_results", paste0(sample.names[1], ".fasta"))
uniquesToFasta(seqtab.nochim, results)

