rule trim_galore:
     input:
        R1 = config["input_folder"]["fastq_files_folder"] + "/{sample}_RNA_R1_merged.fastq.gz",
        R2 = config["input_folder"]["fastq_files_folder"] + "/{sample}_RNA_R2_merged.fastq.gz"
     output:
        config["output_folder"] + "trimmed/{sample}/{sample}_RNA_R1_merged.fastq.gz_trimming_report.txt"
     params:
        folder = config["output_folder"] + "trimmed/{sample}/"
     conda:
        "../envs/trim.yaml"
     threads: 5
     shell:
        "trim_galore --paired -o {params.folder} -j 5 --fastqc --length 0 -q 0 {input.R1} {input.R2}"
