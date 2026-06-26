#!/bin/bash

while IFS= read -r sra || [ -n "$sra" ]; do
    # Ignore empty lines
    [ -z "$sra" ] && continue

    # Clean up hidden Windows characters just in case
    sra=$(echo "$sra" | tr -d '\r')

    echo "Downloading: $sra"

    fasterq-dump "$sra" \
      --outdir /home/miav/scratch/raw_fastq \
      --threads 16 \
      --progress \
      --split-files \
      --include-technical

done < /home/miav/GSE116561/SRR_Acc_List.txt 
