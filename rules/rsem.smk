if config["reads"] == "paired":
    rule RSEM_run:
        input:
            bam = config["output_folder"] + "STAR_mapped/{sample}_Aligned.toTranscriptome.out.bam",
        output:
            config["output_folder"] + "RSEM/{sample}.genes.results"
        singularity: config["SIF"]["RSEM"]
        threads: config["RSEM"]["threads"]
        log: config["output_folder"] + "logs/rsem_{sample}.log"
        params:
            genome_dir = config["RSEM"]["reference"],
            strandedness = config["rsem_strand"],
            tmp_folder = config["output_folder"] + "TMP/",
            output_folder = config["output_folder"] + "RSEM/{sample}"
        shell:
            """
            rsem-calculate-expression --paired-end -p {threads} --alignments {input.bam} --strandedness {params.strandedness} --temporary-folder {params.tmp_folder} {params.genome_dir} {params.output_folder} 2> {log}
            """

