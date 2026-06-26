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

cd /home/miav/scratch/7_tmp_dedup/

# log output
exec > >(tee -a pipeline.log) 2>&1

for bam_file in /home/miav/scratch/6_tmp_bwa/*.bam; do
# extract basename
base_name=$(basename "$bam_file" .bam)

echo "Processing sample: ${base_name}"

outfile="${base_name}_dedup.bam"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING] Step 5: Deduped BAM already exists."
else
echo "[RUNNING] Step 5: Deduplicating..."

# ATTENTION!!!! IS INDEXING NEEDED???
#samtools index ${bam_file}

# 5. UMI tools: Remove PCR duplicates -- reads that mapped to same genomic location that have the same UMI
umi_tools dedup -I ${bam_file} -L "${base_name}_duprm.log" -S "${outfile}" --extract-umi-method read_id --method unique

fi
done

