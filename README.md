# RNAseq pipeline (snakemake)
version v2.1 (singularity/conda)
last update, August 2023

Input: paired end  reads, fastq or bam files, bulk RNAseq data.
Output: Counts (STAR & HTSeq), expression (STAR, Kallisto & RSEM), QCs (NGSderive, fastqc & multiqc), TCR diversity (MiXCR & vdjtools).

Input: single reads, fastq or bam files, RNAseq data.
Output: Counts (STAR & HTSeq), QCs (NGSderive, fastqc & multiqc), TCR diversity (MiXCR & vdjtools).

Optional, not integrated(!): Trimming (Trim Galore), Fusions (STAR fusion)

## ⚠️⚠️ work in process! ⚠️⚠️ ##

## Prepare sif containers
- run `Buid_sif_containers.py` (default package versions used in RNAseq pipeline 23/06)
- or build your own sif containers with selfbuild or pulled docker images


## How to run with the Run_RNApipeline.py shell
1. create a new conda env (or use one in which only snakemake is installed)
```bash
conda create -n snakemake_run snakemake
```
2. activate new environment
```bash
conda activate snakemake_run
```
3. configure config file:
`config/config.yaml`
4. run "Run_RNApipeline.py"
```bash
  python Run_RNApipeline.py
```

```bash

  options:
  -h, --help            show this help message and exit
  -c CORES, --cores CORES
                        Number of cores to be used (int) (default: 1)
  -b BAM, --bam BAM     Start with bam files as input (True or False) (default: False) 
  -s {no,unknown,yes,reverse}, --strandedness {no,unknown,yes,reverse}
                        Strandedness (forward or reverse or unknown) (default: unknown)
```
Example:
```bash
python Run_RNApipeline.py $PATH_INPUT $PATH_OUTPUT -c 5 -s reverse
```

## Alternative: How to run without the Run_RNApipeline.py shell
1. activate snakemake environment
2. configure config files:
`config/config.yaml`
`var/config.yaml`
3. run snakemake in snakemake RNAseq pipeline folder, adjust amount of cores
etc. 
```bash
snakemake --use-conda --use-singularity --singularity-args "-B $PATH_INPUT -B $PATH_OUTPUT -B $PATH_REF" --cores 1 -k
```

### Sample file format 
Sample files should contain the column name "sample_ID". 

### Information on config/config.yaml
"input_folder" in the `config/config/yaml` file locates the folder containing the fastq files. And "output_folder" locates the folder for the output files. Setting the modes to True/False determines the output.

### Updates
- August 2023, integrated RSEM and added more extensive QCs
- June 2023, updated environments and added a python shell
- October 2022, added TCR div with MiXCR and vdjtools
- June 2022, added RSEM (direct TPM quantification) & STAR-fusion rules

### TODO
- add slurm options
- add docker for MiXCR/vdjtools
- integrate trimming and STAR-fusion
- integrate reference preparation STAR, RSEM and Kallisto
- fix bam > fastq rules

