INDIR="/home/miav/scratch/8_stats_star"
OUTDIR="/home/miav/scratch/8_stats_star"

cd $OUTDIR

for bam_file in "$INDIR"/*bam; do

# extract basename
base_name=$(basename "$bam_file" .bam)

### Duplicate removal summary
echo "### Duplicate removal summary: \n" > "$base_name.statsfile.txt"

cat "$base_name.plus.bedgraph" "$base_name.minus.bedgraph" | awk 'BEGIN{ totalcount=0 }{ totalcount += (($3 - $2) * $4) }END{ print totalcount }' >> "$base_name.statsfile.txt"

echo "\n" >> "$base_name.statsfile.txt"


#### Number of crosslinked nucleotides, i.e. positions harbouring crosslinked nucleotides (if both strands are covered, count as 2):
echo "### Number of crosslinked nucleotides: \n" >> "$base_name.statsfile.txt"

cat "$base_name.plus.bedgraph" "$base_name.minus.bedgraph" | awk 'BEGIN{ totalpos=0 }{ totalpos += ($3 - $2) }END{ print totalpos }' >> "$base_name.statsfile.txt"
echo "\n" >> "$base_name.statsfile.txt"

#### Number of stacked crosslink events, i.e. crosslink events on positions with >1 crosslink events:
echo "Number of stacked crosslinked events: \n" >> "$base_name.statsfile.txt"
cat "$base_name.plus.bedgraph" "$base_name.minus.bedgraph" | awk 'BEGIN{ totalstackedcount=0 }{ if($4 > 1) totalstackedcount += (( $3 - $2) * $4) }END{ print totalstackedcount }' >> "$base_name.statsfile.txt"
echo "\n" >> "$base_name.statsfile.txt"

#### Number of nucleotides with stacked crosslink events, i.e. positions with >1 crosslink events:
echo "Number of nucleotides with stacked crosslinke events:\n"  >> "$base_name.statsfile.txt"
cat "$base_name.plus.bedgraph" "$base_name.minus.bedgraph" | awk 'BEGIN{ totalstackedpos=0 }{ if($4 > 1) totalstackedpos += ($3 - $2) }END{ print totalstackedpos }' >> "$base_name.statsfile.txt"
echo "\n" >> "$base_name.statsfile.txt"

#### Number of reads mapped with deletions:
echo "Number of reads mapped with deletions: \n" >> "$base_name.statsfile.txt"
cut -f6 "$base_name.sam" | grep D | wc -l >> "$base_name.statsfile.txt"
echo "\n" >> "$base_name.statsfile.txt"

#### Number of reads mapped with insertions:
echo "Number of reads mapped with insertions: \n" >> "$base_name.statsfile.txt"
cut -f6 "$base_name.sam" | grep I | wc -l >> "$base_name.statsfile.txt"
echo "\n" >> "$base_name.statsfile.txt"

done

