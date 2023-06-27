if config["paired_end"] == True:
    rule RSEM_run:
        input:
            bam = config["output_folder"] + "STAR_mapped/{sample}_Aligned.toTranscriptome.out.bam",
        output:
            config["rsem"]["python_folder"] + "{sample}.isoforms.results"
        conda:
            "../envs/rsem.yaml"
        threads:
            config["threads_set"]["threads_sys_STAR"]
        log: config["output_folder"] + "logs/rsem_{sample}.log"
        params:
            genome_dir = "/DATA/j.traets/Reference_files/homo_sapiens/GRCh38_ensembl_105_primary_RSEM/GRCh38_105",
            output_name = config["output_folder"] + "RSEM/"
        shell:
            "rsem-calculate-expression --paired-end -p {threads} --alignments {input.bam} {params.genome_dir} {wildcards.sample} --forward-prob 0 2> {log}"

    rule RSEM_mv:
        input:
            config["rsem"]["python_folder"] + "{sample}.isoforms.results",
        output:
            config["output_folder"] + "RSEM/{sample}.isoforms.results"
        params:
            folder_mv = config["output_folder"] + "RSEM/"
        shell:
            "mv {wildcards.sample}* {params.folder_mv}"

