# RNAseq pipeline
version v2.1 (singularity/conda)
updated, June 2023

Input: paired end  reads, fastq or bam files, bulk RNAseq data
Output: Counts (HTSeq), TPM (Kallisto), QC (fastqc, multiqc on fastqs), strandedness (NGSderive), TCR diversity (MiXCR and vdjtools)

Input: single reads, fastq or bam files, RNAseq data
Output: Counts (HTSeq), QC (fastqc, multiqc on fastqs), strandedness (NGSderive), TCR diversity (MiXCR and vdjtools)

Optional, not integrated(!): Trimming (Trim Galore), Fusions (STAR fusion), TPM quantitative (RSEM)

## work in process! See TODOs ##

## Prepare sif containers
- via "Buid_sif_containers.py" (default package versions used in RNAseq pipeline 23/06)
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
  python Run_RNApipeline.py {fastq_folder} {output_folder}
```

```bash
  positional arguments:
  input                 Location of the fastq files
  output                Location of the output files

  options:
  -h, --help            show this help message and exit
  -c CORES, --cores CORES
                        Number of cores to be used (int) (default: 1)
  -r {single,paired}, --reads {single,paired}
                        Paired or single end (paired or single) (default: single)
  -b BAM, --bam BAM     Start with bam files as input (default: False) (default: False)
  -s {no,unknown,yes,reverse}, --strandedness {no,unknown,yes,reverse}
                        Strandedness (forward or reverse or unknown) (default: unknown)
```
Example:
```bash
python Run_RNApipeline.py $PATH_INPUT $PATH_OUTPUT -r paired -s yes
```

## Alternative: How to run without the Run_RNApipeline.py shell
1. activate snakemake environment
2. configure config files:
`config/config.yaml`
`var/config.yaml`
3. run snakemake in snakemake RNAseq pipeline folder, adjust amount of cores
e.g. 
```bash
snakemake --use-conda --use-singularity --singularity-args "-B $PATH_INPUT -B $PATH_OUTPUT -B $PATH_REF" --cores 1 -k
```

### Sample file format 
Sample files should contain the column name "sample_ID".

### Updates
- June 2023, updated environments and added a python shell
- October 2022, added TCR div with MiXCR and vdjtools
- June 2022, added RSEM (direct TPM quantification) & STAR-fusion rules

### TODO
- add slurm options
- add docker for MiXCR/vdjtools
- integrate trimming, RSEM and STAR-fusion 
- fix bam > fastq rules

### Gitlab
https://gitlab.rhpc.nki.nl/j.traets/snakemake_rnaseq_pipeline_sr
