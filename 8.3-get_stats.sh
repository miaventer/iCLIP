INDIR="/home/miav/scratch/7_tmp_dedup/"
OUTDIR="/home/miav/scratch/8_tmp_stats/"

cd $OUTDIR

for bam_file in "$INDIR"/*bam; do

# extract basename
base_name=$(basename "$bam_file" .bam)


export LC_COLLATE=C
sort -k1,1 -k2,2n "$base_name.shifted.plus.bedgraph" > "$base_name.shifted.plus.tmp" && mv "$base_name.shifted.plus.tmp" "$base_name.shifted.plus.bedgraph"
sort -k1,1 -k2,2n "$base_name.shifted.minus.bedgraph" > "$base_name.shifted.minus.tmp" && mv "$base_name.shifted.minus.tmp" "$base_name.shifted.minus.bedgraph"

#### Conversion of bedgraph files to bw file format files using bedGraphToBigWig of the kentUtils suite
bedGraphToBigWig  "$base_name.shifted.minus.bedgraph" /home/miav/genomes/GRCm38.p4.genome.fa.fai "$base_name.shifted.minus.bw"
bedGraphToBigWig  "$base_name.shifted.plus.bedgraph" /home/miav/genomes/GRCm38.p4.genome.fa.fai "$base_name.shifted.plus.bw"

done
