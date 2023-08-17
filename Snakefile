###################################
#### Snakemake pipeline RNAseq ####
###################################

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
