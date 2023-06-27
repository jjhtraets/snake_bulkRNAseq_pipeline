if config["paired_end"] == True:
    rule STAR_fastq_fusion:
        input:
            fastq1 = config["input_folder"]["fastq_files_folder"] + "/{sample}.1.fastq.gz", # adjust accordingly
            fastq2 = config["input_folder"]["fastq_files_folder"] + "/{sample}.2.fastq.gz" # adjust accordingly
        output:
            config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam"
        conda:
            "../envs/star.yaml"
        threads:
            config["threads_set"]["threads_sys_STAR"]
        log: "logs/star_{sample}.log"
        params:
            genome_dir = config["STAR"]["reference"],
            output_name = config["output_folder"] + "STAR_mapped/{sample}_"
        shell:
            "STAR –genomeDir {params.genome_dir} --outReadsUnmapped None --chimSegmentMin 12 --chimJunctionOverhangMin 12 --chimOutJunctionFormat 1 --alignSJDBoverhangMin 10 --alignMatesGapMax 100000 --alignIntronMax 100000 --alignSJstitchMismatchNmax 5 -1 5 5 --runThreadN {threads} --outSAMstrandField intronMotif --outSAMunmapped Within --outSAMtype BAM Unsorted --readFilesIn {input.fastq1}  {input.fastq2} --outSAMattrRGline ID:GRPundef --chimMultimapScoreRange 10 --chimMultimapNmax 10 --chimNonchimScoreDropMin 10 –peOverlapNbasesM 0.1 --genomeLoad NoSharedMemory --twopassMode Basic --readFilesCommand zcat --outFileNamePrefix {params.output_name}"

