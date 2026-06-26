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

cd /home/miav/scratch/3_qc/

# log output
exec > >(tee -a pipeline.log) 2>&1

for fastq_file in /home/miav/scratch/raw_fastq/*.fastq; do
# extract basename
base_name=$(basename "$fastq_file" .fastq)

echo "Processing sample: ${base_name}"

# ==============================================================================
# Step 1: Filter to only include reads that have high-quality barcodes
# ==============================================================================
outfile="${base_name}_filtered.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING] Step 1: Filtered FASTQ already exists."
else

echo "Running fastX trimmer"

cat ${fastq_file} | fastx_trimmer -l 14 | fastq_quality_filter -q 10 -p 100 | awk 'FNR%4==1 { print $1 }' | sed 's/@//' > "${base_name}_data.qualFilteredIDs.list"
#seqtk subseq $fastq_file "${base_name}_data.qualFilteredIDs.list" | sed 's/ /#/g; s/\\//#/g' > "${outfile}"
fi
done




