ASV_TABLE = "ASV_results/ASV_table.csv"
SWARM_TXT = "OTU_results/swarm_log.txt"

ASV_m <- t(read.csv(ASV_TABLE, row.names=1))
OTU_clusters <- readLines(SWARM_TXT)
OTU_list <- list()

for (OTU in OTU_clusters) {
  ASVs <- strsplit(OTU, " ")[[1]]
  idx_list <- list()
  for (ASV in ASVs) {
    idx_list <- append(idx_list, as.integer(sub(".*sq(\\d+).*", "\\1", ASV)))
  }
  rows <- ASV_m[unlist(idx_list), , drop=FALSE]
  ASV_m[idx_list[[1]], ] <- apply(rows, 2, sum)
  OTU_list <- append(OTU_list, idx_list[[1]])
}

OTU_m <- ASV_m[unlist(OTU_list), ]

sequences <- rownames(OTU_m)
OTU_ids <- paste0("OTU", seq_along(sequences))
rownames(OTU_m) <- OTU_ids

write.csv(OTU_m, "OTU_results/OTU_table.csv")

fasta_lines <- character(length(sequences) * 2)
for (i in seq_along(sequences)) {
  fasta_lines[(i - 1) * 2 + 1] <- paste0(">", OTU_ids[i])
  fasta_lines[(i - 1) * 2 + 2] <- sequences[i]
}

writeLines(fasta_lines, "OTU_results/OTU_sequences.fasta")


