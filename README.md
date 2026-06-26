# iCLIP
iCLIP pipeline for use on Compute Canada

The pipeline is largely based on "iCLIP data analysis: A complete pipeline from sequencing reads to RBP binding sites"(https://www.sciencedirect.com/science/article/pii/S1046202318304948#ab005) from Kathi Zarnack's group.

The steps are as follows:
1. Download the data from GEO using SRA toolkit.
2. Index the genome for the alignment software (in this case STAR)
3. Perform quality control
4. Extract the UMI from the read and place it in the sequence header
5. Remove barcode, UMI, adapters, and poor quality reads
6. Align reads to the genome
7. Remove technical artefacts based on the UMI
8. Get some key statistics on the created files
9. Peak calling

The individual steps are housed in their own scripts, and then there's a Slurm submission script to run the steps in order. This makes it easier to rerun certain parts if needed. 

After peak calling, I use BindingSiteFinder(https://www.bioconductor.org/packages/release/bioc/vignettes/BindingSiteFinder/inst/doc/vignette.html#33_Performing_the_main_analysis) in R to do the rest of the analysis.

TO DO:
- remove BWA option
- fix directories in scripts
- find a way to automate. maybe snakemake
