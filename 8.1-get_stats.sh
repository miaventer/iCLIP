INDIR="/home/miav/scratch/7_tmp_dedup/"
OUTDIR="/home/miav/scratch/8_tmp_stats/"

cd $OUTDIR

for bam_file in "$INDIR"/*bam; do

# extract basename
base_name=$(basename "$bam_file" .bam)

# sort and index : ATTENTION!!! IS INDEXING NEEDED??
#samtools sort -@ 16 -o $bam_file $bam_file
#samtools index $bam_file

# convert to sam
#samtools view $bam_file -o "$base_name.sam"

#### Convert all read locations to intervals in bed file format using BEDTools
bedtools bamtobed -i $bam_file > "$base_name.bed"

#### Shift intervals depending on the strand by 1 bp upstream using BEDTools
bedtools shift -m 1 -p -1 -i "$base_name.bed" -g /home/miav/genomes/GRCm38.p4.genome.fa.fai > "$base_name.shifted.bed"
 

#### Extract the 5' end of the shifted intervals and pile up into coverage track in bedgraph file format (separately for each strand) using BEDTools (in case of RPM-normalised coverage tracks, use additional parameter -scale with 1,000,000/#mappedReads)
 
bedtools genomecov -bg -strand + -5 -i "$base_name.shifted.bed" -g /home/miav/genomes/GRCm38.p4.genome.fa.fai > "$base_name.shifted.plus.bedgraph"
bedtools genomecov -bg -strand - -5 -i "$base_name.shifted.bed" -g /home/miav/genomes/GRCm38.p4.genome.fa.fai > "$base_name.shifted.minus.bedgraph"

done

