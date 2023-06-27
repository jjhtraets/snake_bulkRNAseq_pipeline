###################################
#### Snakemake pipeline RNAseq ####
###################################

## Includes:
# HTseq Counts
# Quality control with fastqc/multiqc
# Strandedness check
# TODO: Check if paired-end, STAR rule adjustment, also TPMs with Kallisto when paired end
# TODO: Combine HTseq files, requires script
# TODO: Integrate bam > fastq rules for Alex
# TODO: Make more general (fastq names etc)

## Checks:
# remove STAR two-pass mode?

include: "rules/common.smk"
include: "rules/qc.smk"
include: "rules/mapping.smk"
include: "rules/counts.smk"
include: "rules/TPM.smk"
include: "rules/strand.smk"
#include: "rules/rsem.smk"
include: "rules/MiXCR.smk"

rule all:
    input:
        output_rules_all()
