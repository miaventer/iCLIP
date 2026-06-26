
while IFS= read -r sra || [ -n "$sra" ]; do
    # Ignore empty lines
    [ -z "$sra" ] && continue
    
    # Clean up hidden Windows characters just in case
    sra=$(echo "$sra" | tr -d '\r')
    
    echo "Downloading: $sra"
    
    fasterq-dump "$sra" \
      --outdir /home/miaventer/GSE116561/ \
      --threads 4 \
      --progress \
      --split-files

done < /home/miaventer/GSE116561/SRR_Acc_List_Bcells.txt
