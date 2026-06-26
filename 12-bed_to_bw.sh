
cd /home/miav/GSE116561/deduped_files

for bed_file in /home/miav/GSE116561/deduped_files/*bedgraph; do

# extract basename
base_name=$(basename "$bed_file" .bedgraph)

export LC_COLLATE=C
sort -k1,1 -k2,2n $bed_file > tmp.bedgraph && mv tmp.bedgraph $bed_file
bedGraphToBigWig $bed_file /home/miav/genomes/GRCm38.p4.genome.fa.fai "$base_name.bw"

done 

