# common script
import glob
import pandas as pd

configfile: "config/config.yaml"
configfile: "var/config_user.yaml"

samples = pd.read_table(config["samples"])

# collect output
def output_rules_all():
    count_output =  expand(config["output_folder"]+"Counts/{sample}_HTseqCount.txt",sample=samples["sample_ID"]),
    bam_output =  expand(config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam",sample=samples["sample_ID"]),
    qcs_report = config["output_folder"]+"multiqc/multiqc_report_QCs.html",
    qcs_counts_report = config["output_folder"] + "multiqc/multiqc_report_counts_QCs.html"
    check_s = config["output_folder"]+"ngsderive/strandedness.txt",
    count_file  = config["output_folder"]+"Counts/Count_matrix_HTseq.txt",
    tpm_rsem  = expand(config["output_folder"] + "RSEM/{sample}.isoforms.results" ,sample=samples["sample_ID"]),
    tcr_div  = expand(config["output_folder"] + "MiXCR/converted.{sample}.txt" ,sample=samples["sample_ID"]),
    tpms = expand(config["output_folder"]+"TPMs/{sample}/abundance.tsv",sample=samples["sample_ID"]), 
    rsem = expand(config["output_folder"]+"RSEM/{sample}",sample=samples["sample_ID"]), 

    modes = list()
    if config["reads"] == "paired":
        if config["run_modes"]["STAR"] == True:
            modes.append(bam_output)
        if config["run_modes"]["counts"] == True:
            modes.append(count_output)
            modes.append(count_file)
        if config["run_modes"]["QCs"] == True and config["run_modes"]["counts"] == False:
            modes.append(qcs_report)
            modes.append(check_s)
        if config["run_modes"]["QCs"] == True and config["run_modes"]["counts"] == True:
            modes.append(qcs_counts_report)
            modes.append(check_s)
        if config["run_modes"]["mixcr"] == True:
            modes.append(tcr_div)
        if config["run_modes"]["kallisto"] == True:
            modes.append(tpms)
        if config["run_modes"]["RSEM"] == True:
            modes.append(rsem)

    if config["reads"] == "single":
        if config["run_modes"]["STAR"] == True:
            modes.append(bam_output)
        if config["run_modes"]["counts"] == True:
            modes.append(count_output)
            modes.append(count_file)
        if config["run_modes"]["QCs"] == True and config["run_modes"]["counts"] == False:
            modes.append(qcs_report)
            modes.append(check_s)
        if config["run_modes"]["QCs"] == True and config["run_modes"]["counts"] == True:
            modes.append(qcs_counts_report)
            modes.append(check_s)

    return modes

def multiqc_input():
    input_folders = list()
    fastqc_folder = config["output_folder"]+ "fastqc/"
    input_folders.append(fastqc_folder)
    if config["run_modes"]["STAR"] or config["run_modes"]["QCs"]:
        star_folder = config["output_folder"]+ "STAR_mapped/"
        ngs_folder = config["output_folder"]+ "ngsderive/"
        input_folders.append([star_folder,ngs_folder])
    if config["run_modes"]["counts"]:
        counts_folder = config["output_folder"]+ "Counts/"
        output_folder = config["output_folder"]+ "multiqc/"
        input_folders.append([counts_folder,output_folder])
        
    return input_folders
    
    
    