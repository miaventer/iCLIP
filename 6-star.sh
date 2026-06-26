## May 28 2026
## Mia Venter

# iCLIP processing pipeline adapted from the following protocols:
# https://www.sciencedirect.com/science/article/pii/S1046202318304948#s0005
# https://www.nature.com/articles/s41590-018-0208-x#Sec10


# the procedure is as follows:
# 1. Bash, FastX_trimmer, and seqtk: Filter to only include reads that have high-quality barcodes
# 2. UMI tools: Extract the UMI and place it in the fastq header
# 3. Cutadapt: Remove low quality bases and 3' adapter
# 4. Star: Align to genome (mm9)
# 5. UMI tools: Remove PCR duplicates -- reads that mapped to same genomic location that have the same UMI
# 6. ClipAnalyze: Peak calling (which will be done in a seperate R script)

cd /home/miav/scratch/6_star/

# log output
exec > >(tee -a pipeline.log) 2>&1

for fastq_file in /home/miav/scratch/5_cutadapt/*.fastq; do
# extract basename
base_name=$(basename "$fastq_file" .fastq)

echo "Processing sample: ${base_name}"


# ==============================================================================
# Step 4: STAR Alignment to genome (mm9)
# ==============================================================================
#
# # STAR default settings are optimised for mammalian genomes

aligned_bam="${base_name}_aligned_Aligned.sortedByCoord.out.bam"

if [ -f "$aligned_bam" ]; then
    echo "[SKIPPING] Step 4: Alignment BAM already exists."
else
echo "[RUNNING] Step 4: Aligning with STAR..."

STAR --runMode alignReads --genomeDir /home/miav/genomes --outFilterMismatchNoverReadLmax 0.04 --outFilterMismatchNmax 999 --outFileNamePrefix $base_name --outFilterMultimapNmax 1 --alignEndsType Extend5pOfRead1 --sjdbGTFfile /home/miav/genomes/gencode.vM10.annotation.gtf --outReadsUnmapped Fastx --outSJfilterReads Unique --outSAMtype BAM SortedByCoordinate --readFilesIn ${fastq_file}


fi
done
