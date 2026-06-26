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

cd /home/miav/scratch/4_extract/

# log output
exec > >(tee -a pipeline.log) 2>&1

for fastq_file in /home/miav/scratch/3_qc/*.fastq; do
# extract basename
base_name=$(basename "$fastq_file" .fastq)

echo "Processing sample: ${base_name}"

# UMI (Read / PCR duplicate identifier) is the first seven nucleotides of the (high quality) filtered fastq file
# we want to also remove the first barcode i.e., first 14 nucleotides

outfile="${base_name}_UMI_extracted.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING] Step 2: UMI extracted FASTQ already exists."
else

echo "Running umi tools to extract umi"

umi_tools extract --bc-pattern=NNNNNNNNNNNNNN -L "${base_name}_extract.log" --stdin="${fastq_file}" --stdout="${outfile}"
fi
done

















