cd /home/miav/scratch/6_bwa/

# log output
exec > >(tee -a pipeline.log) 2>&1

for fastq_file in /home/miav/scratch/5_cutadapt/*.fastq; do
# extract basename
base_name=$(basename "$fastq_file" .fastq)

echo "Processing sample: ${base_name}"


# ==============================================================================
# Step 4: BWA Alignment to genome (mm10)
# ==============================================================================
#
if [ -f "$base_name.sai" ]; then
    echo "[SKIPPING] Step 4: Alignment BAM already exists."
else
echo "[RUNNING] Step 4: Aligning with BWA..."
bwa aln -t 16 /home/miav/genomes/GRCm38.p4.genome.fa $fastq_file > "$base_name.sai"

fi

echo "[RUNNING] Creating SAM file via bwa samse..."
bwa samse /home/miav/genomes/GRCm38.p4.genome.fa "$base_name.sai" "$fastq_file" > "$base_name.sam"

echo "[RUNNING] Sorting and converting to BAM..."
samtools sort "$base_name.sam" -o "$base_name.bam"

echo "[RUNNING] Indexing BAM..."
samtools index "$base_name.bam"

done



