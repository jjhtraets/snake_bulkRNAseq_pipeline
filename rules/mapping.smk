# Only if required, TODO: make into sif's and clean up
if config["bam_to_fastq_r"] == True:
    rule sort_bam:
        input:
            config["input_folder"]["bam_files_folder"]+"/{sample}.bam"
        output:
            temp(config["input_folder"]["bam_files_folder"]+"/{sample}_namesorted.bam")
        conda:
            "../envs/misc.yaml"
        threads: 2
        shell:
            "samtools sort -n {input} > {output} "

    rule bam_to_fastq:  # Picard SamToFastq can split the paired and unpaired reads
        input:
            config["input_folder"]["bam_files_folder"]+"/{sample}_namesorted.bam"
        output:
            reads1out=config["input_folder"]+"/{sample}.1.fastq.gz",
            reads2out=config["input_folder"]+"/{sample}.2.fastq.gz",
            unpaired=config["input_folder"]+"/{sample}_unpaired.fastq.gz"
        threads: 1
        conda:
            "../envs/misc.yaml"
        shell:
            "picard SamToFastq -I {input} -F {output.reads1out} -F2 {output.reads2out} -FU {output.unpaired}"

if config["reads"] == "paired":
    rule STAR_fastq:
        input:
            fastq1 = config["input_folder"] + "{sample}" + config["read_name"]["R1"] + ".fastq.gz", 
            fastq2 = config["input_folder"] + "{sample}" + config["read_name"]["R2"] + ".fastq.gz"
        output:
            config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam",
            config["output_folder"] + "STAR_mapped/{sample}_Aligned.toTranscriptome.out.bam"
        singularity: config["SIF"]["STAR"]
        threads: config["STAR"]["threads"]
        log: config["output_folder"] + "logs/star_{sample}.log"
        params:
            genome_dir = config["STAR"]["reference"],
            param1 = config["STAR"]["mode"],
            param2 = config["STAR"]["param_sam"],
            param3 = config["STAR"]["other"],
            output_name = config["output_folder"] + "STAR_mapped/{sample}_"
        shell:
            """
            STAR --genomeDir {params.genome_dir} --readFilesIn {input.fastq1} {input.fastq2} {params.param1} \
            {params.param2} {params.param3} --runThreadN {threads} --outFileNamePrefix {params.output_name} \
            --quantMode TranscriptomeSAM 2> {log}
            """

if config["reads"] == "single":
    rule STAR_fastq_s:
        input:
            fastq1 = config["input_folder"] + "{sample}" + config["read_name"]["R1"] + ".fastq.gz",
        output:
            config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam"
        singularity: config["SIF"]["STAR"]
        threads: config["STAR"]["threads"]
        log: config["output_folder"] + "logs/star_{sample}.log"
        params:
            genome_dir = config["STAR"]["reference"],
            param1 = config["STAR"]["mode"],
            param2 = config["STAR"]["param_sam"],
            param3 = config["STAR"]["other"],
            output_name = config["output_folder"] + "STAR_mapped/{sample}_"
        shell:
            """
            STAR --genomeDir {params.genome_dir} --readFilesIn {input.fastq1} {params.param1} \
            {params.param2} {params.param3} --runThreadN {threads} --outFileNamePrefix {params.output_name} 2> {log}
            """
