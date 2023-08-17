if config["reads"] == "paired":
    rule fastqc:
        input:
            reads = [config["input_folder"] + "{sample}" + config["read_name"]["R1"] + ".fastq.gz", config["input_folder"] + "{sample}" + config["read_name"]["R2"] + ".fastq.gz"]
        output:
            f1 = config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",
            f2 = config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R2"] + "_fastqc.html"
        singularity: config["SIF"]["fastqc"]
        threads: 1
        params:
            output_folder = config["output_folder"]+ "fastqc/"
        shell:
            """
            fastqc -o {params.output_folder} -t {params.threads} {input.reads}
            """

    rule multiqc_QCs:
        input:
            f1 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",sample=samples["sample_ID"]),
            f2 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R2"] + "_fastqc.html",sample=samples["sample_ID"]),
            star = expand(config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam",sample=samples["sample_ID"]),
            check_s = config["output_folder"]+"ngsderive/strandedness.txt",
        output:
            config["output_folder"] + "multiqc/multiqc_report_QCs.html"
        singularity: config["SIF"]["multiqc"]
        threads: 1
        params:
            fastqc_folder = config["output_folder"]+ "fastqc/",
            star_folder = config["output_folder"]+ "STAR_mapped/",
            ngs_folder = config["output_folder"]+ "ngsderive/"
        shell:
            """
            multiqc {params.fastqc_folder} {params.star_folder} {params.ngs_folder} -o {params.output_folder} -n multiqc_report_QCs -f
            """

    rule multiqc_counts:
        input:
            f1 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",sample=samples["sample_ID"]),
            f2 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R2"] + "_fastqc.html",sample=samples["sample_ID"]),
            star = expand(config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam",sample=samples["sample_ID"]),
            check_s = config["output_folder"]+"ngsderive/strandedness.txt",
            count_file  = config["output_folder"]+"Counts/Count_matrix_HTseq.txt",
        output:
            config["output_folder"] + "multiqc/multiqc_report_counts_QCs.html"
        singularity: config["SIF"]["multiqc"]
        threads: 1
        params:
            counts_folder = config["output_folder"]+ "Counts/"
            fastqc_folder = config["output_folder"]+ "fastqc/",
            star_folder = config["output_folder"]+ "STAR_mapped/",
            ngs_folder = config["output_folder"]+ "ngsderive/"
        shell:
            """
            multiqc {params.counts_folder} {params.fastqc_folder} {params.star_folder} {params.ngs_folder} -o {params.output_folder} -n multiqc_report_counts_QCs -f
            """
            

if config["reads"] == "single":
    rule fastqc_s:
        input:
            reads = config["input_folder"] + "{sample}" + config["read_name"]["R1"] + ".fastq.gz"
        output:
            f1 = config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",
        singularity: config["SIF"]["fastqc"]
        threads: 1
        params:
            output_folder = config["output_folder"]+ "fastqc/"
        shell:
            """
            fastqc -o {params.output_folder} -t {threads} {input.reads}
            """

    rule multiqc_s:
        input:
            f1 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",sample=samples["sample_ID"])
        output:
            config["output_folder"] + "multiqc/multiqc_report.html"
        singularity: config["SIF"]["multiqc"]
        threads: 1
        params:
            input_folder = config["output_folder"]+ "fastqc/",
            output_folder = config["output_folder"]+ "multiqc/"
        shell:
            """
            multiqc {params.input_folder} -o {params.output_folder} -n multiqc_report
            """
