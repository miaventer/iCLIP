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

cd /home/miav/scratch/5_cutadapt/

# log output
exec > >(tee -a pipeline.log) 2>&1

for fastq_file in /home/miav/scratch/4_extract/*.fastq; do
# extract basename
base_name=$(basename "$fastq_file" .fastq)

echo "Processing sample: ${base_name}"

# ==============================================================================
# Step 3: Cutadapt to remove low quality and 3' adapter
# ==============================================================================

outfile="${base_name}_adapter_removed.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING] Step 3: Adapter-trimmed FASTQ already exists."
else

echo "Running cutadapt"
cutadapt -q 10 -a GTGTCAGTCACTTCCAGCGG -o "${outfile}" "${fastq_file}" -j 16 -m 25
fi
done

