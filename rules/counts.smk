rule sort_bam:
     input:
        config["output_folder"] + "STAR_mapped/{sample}_Aligned.sortedByCoord.out.bam"
     output:
        config["output_folder"] + "STAR_bam/{sample}_NameSorted.bam"
     singularity: config["SIF"]["samtools"]
     threads: 5
     shell:
        """
        samtools sort -@ 5 -n {input} > {output}
        """

rule ht_seq:
     input:
        bam = config["output_folder"] + "STAR_bam/{sample}_NameSorted.bam",
     output:
        config["output_folder"] + "Counts/{sample}_HTseqCount.txt"
     singularity: config["SIF"]["htseq"]
     log: config["output_folder"] + "logs/htseq_{sample}.log"
     threads: 2
     params:
        gtf = config["HTSeq"]["reference"],
        setting_ht = config["HTSeq"]["params"],
        strandedness = config["strandedness"]
     shell:
         """
         htseq-count {params.setting_ht} --stranded={params.strandedness} -i gene_id -f bam {input.bam} {params.gtf} > {output}
         """

rule ht_seq_merge:
     input:
        expand(config["output_folder"] + "Counts/{sample}_HTseqCount.txt",sample=samples["sample_ID"])
     output:
        config["output_folder"] + "Counts/Count_matrix_HTseq.txt"
     params:
        folder_counts = config["output_folder"] + "/Counts" 
     shell:
        """
        Rscript scripts/merge_counts.R {params.folder_counts}
        """
