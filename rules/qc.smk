if config["reads"] == "paired":
    rule fastqc:
        input:
            reads = [config["input_folder"] + "{sample}" + config["read_name"]["R1"] + ".fastq.gz", config["input_folder"] + "{sample}" + config["read_name"]["R2"] + ".fastq.gz"]
        output:
            f1 = config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",
            f2 = config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R2"] + "_fastqc.html"
        singularity: config["SIF"]["fastqc"]
        params:
            threads = "1",
            output_folder = config["output_folder"]+ "fastqc/"
        shell:
            "fastqc -o {params.output_folder} -t {params.threads} {input.reads}"

    rule multiqc:
        input:
            f1 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R1"] + "_fastqc.html",sample=samples["sample_ID"]),
            f2 = expand(config["output_folder"] + "fastqc/{sample}" + config["read_name"]["R2"] + "_fastqc.html",sample=samples["sample_ID"])
        output:
            config["output_folder"] + "multiqc/multiqc_report.html"
        singularity: config["SIF"]["multiqc"]
        params:
            threads = "1",
            input_folder = config["output_folder"]+ "fastqc/",
            output_folder = config["output_folder"]+ "multiqc/"
        shell:
            "multiqc {params.input_folder} -o {params.output_folder} -n multiqc_report"

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
