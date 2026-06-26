#!/bin/bash
#SBATCH --account=def-lkmahal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1      # Number of MPI processes on this node
#SBATCH --mem=64G                # Total memory for the node
#SBATCH --time=01:00:00           # Time limit (HH:MM:SS)
#SBATCH --mail-type=END,FAIL     # Notifications for job success (END) and failure (FAIL)
#SBATCH --mail-user=mia.venter@ualberta.ca  
#SBATCH --job-name=test_align

#module load sra-toolkit/3.0.9
#./1-download_data.sh

#STEP 2 
#module load star/2.7.11b
#./2-star_index.sh

# STEP 3
#module purge
#module load StdEnv/2020
#module load fastx-toolkit
#./3.1-quality_control.sh

#module swap StdEnv/2020 StdEnv/2023
#module load seqtk
#./3.2-quality_control.sh

#STEP 4
#module purge
#module load python/3.11
#virtualenv --no-download $SLURM_TMPDIR/env
#source $SLURM_TMPDIR/env/bin/activate
#pip install --no-index --upgrade pip

#pip install --no-index -r /home/miav/GSE116561/umi_req.txt
#./4-extract_umi.sh
#deactivate

# STEP 5
#module purge
#module load python/3.14
#virtualenv --no-download $SLURM_TMPDIR/env
#source $SLURM_TMPDIR/env/bin/activate
#pip install --no-index --upgrade pip

#pip install --no-index -r /home/miav/GSE116561/cutadapt_req.txt
#./5-cutadapt.sh

#deactivate

# STEP 6 - STAR
#module purge
#module load star/2.7.11b
#./6-star.sh

# STEP 6 - BWA
#module load bwa
#module load samtools
#bwa index -a bwtsw /home/miav/genomes/GRCm38.p4.genome.fa
#./6-bwa.sh

# STEP 7 - DEDUP
#module purge
module load python/3.11
virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip

pip install --no-index -r /home/miav/GSE116561/umi_req.txt

module load samtools
./7-dedup.sh

deactivate

# STEP 8 - GET STATS
module purge
module load samtools
module load bedtools
./8.1-get_stats.sh
#./8.2-get_stats.sh

module purge
module load kent_tools/486
./8.3-get_stats.sh


# STEP 9 -  PURECLIP
#module load samtools
#module load bedtools
#./9.1-pureclip.sh
#./9.2-pureclip.sh










