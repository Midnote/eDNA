#!bin/bash

in_dir="results"
out_dir="fasta_results"
mkdir -p "fasta_results"

format_name() {
  local src="$1"
  local base stem
  base="$(basename -- "$src")"
  stem="${base%.fastq.gz}"
  echo "${stem}.fasta.gz"
}

process_file() {
  local src="$1" dst="$2"
  seqtk seq -a "$src" > "$dst"
}

find "$in_dir" -type f -print0 |
while read -d '' src; do
  new="$(format_name "$src")"
  dst="$out_dir/$new"
  process_file "$src" "$dst"
done
