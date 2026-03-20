library(dada2)

work_dir <- "/storage/intern_belief/practice"

fnFs <- sort(list.files(file.path(work_dir, "dada2raw"), pattern="_R1_001.fastq.gz", full.names = TRUE))
fnRs <- sort(list.files(file.path(work_dir, "dada2raw"), pattern="_R2_001.fastq.gz", full.names = TRUE))
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

results <- file.path(work_dir, "asv_results", "pooled.fasta")
uniquesToFasta(seqtab.nochim, results)

write.csv(seqtab.nochim, file = "../asv_results/ASV_table.csv")
