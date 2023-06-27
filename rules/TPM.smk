if config["reads"] == "paired":
    rule kallisto:
        input:
            fastq1 = config["input_folder"] + "/{sample}.1.fastq.gz",
            fastq2 = config["input_folder"] + "/{sample}.2.fastq.gz"
        output:
            config["output_folder"]+"TPMs/{sample}/abundance.tsv"
        params:
            index= config["kallisto"]["reference"],
            output_folder = config["output_folder"]+"TPMs/{sample}/",
            strandedness = config["kallisto_strand"]
        threads: config["kallisto"]["threads"]
        log: "logs/kallisto_{sample}.log"
        singularity: config["SIF"]["kallisto"]
        shell:
            """
            kallisto quant -i {params.index} -o {params.output_folder} --fr-stranded --fusion -b 10 {input.fastq1} {input.fastq2} -t {threads}
            """
