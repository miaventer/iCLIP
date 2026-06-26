OUTDIR="/home/miav/scratch/9_merged_star"
INDIR="/home/miav/scratch/9_merged_star"
cd $OUTDIR

for bam_file in "$INDIR"/*bam; do

# extract basename
base_name=$(basename "$bam_file" .bam)

echo "Processing sample: ${base_name}"

if [ -f "$base_name.crosslink_sites.bed" ]; then
    echo "[SKIPPING] Step 9: Crosslinks already exist."
else
echo "[RUNNING] Step 9: PureCLIP..."

/home/miav/GSE116561/PureCLIP/build/pureclip -i $bam_file -bai "$bam_file.bai" -g /home/miav/genomes/GRCm38.p4.genome.fa -ld -nt 16 -o "$base_name.crosslink_sites.bed" -or "$base_name.crosslink_regions.bed"

fi
done
