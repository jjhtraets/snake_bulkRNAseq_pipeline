rule mixcr_run:
     input:
        f1 = config["input_folder"] + "/{sample}" + config["read_name"]["R1"] + ".fastq.gz",
        f2 = config["input_folder"] + "/{sample}" + config["read_name"]["R2"] + ".fastq.gz"
     output:
        config["output_folder"] + "MiXCR/{sample}.clns"
     threads: config["kallisto"]["threads"]
     params: 
        output = config["output_folder"]+ "MiXCR/",
        jar = config["MiXCR"]["jar_MiXCR"]
     shell:
        "cd {params.output} && java -Xmx4G -jar {params.jar} analyze shotgun --species hsa --starting-material rna --receptor-type tcr {input.f1} {input.f2} {wildcards.sample} -t {threads}"

rule mixcr_convert:
     input:
        config["output_folder"] + "MiXCR/{sample}.clns"
     output:
        config["output_folder"] + "MiXCR/{sample}.txt"
     threads: 2
     params: 
        jar = config["MiXCR"]["jar_MiXCR"]
     shell:
        "java -Xmx4G -jar {params.jar} exportClones {input} {output}"

rule vdjtools_convert:
     input:
        config["output_folder"] + "MiXCR/{sample}.txt"
     output:
        config["output_folder"] + "MiXCR/converted.{sample}.txt"
     threads: 2
     params: 
        jar = config["MiXCR"]["jar_vdjtools"]
     shell:
        "java -Xmx4G -jar {params.jar_vdjtools} Convert -S mixcr {input} converted && mv converted.{wildcards.sample}.txt {output}"

rule vdjtools_diversity:
     input:
        config["output_folder"] + "MiXCR/converted.{sample}.txt"
     output:
        config["output_folder"] + "MiXCR/converted.{sample}.diversity.strict.exact.txt"
     threads: 2
     params: 
        jar = config["MiXCR"]["jar_vdjtools"]
     shell:
        "java -Xmx4G -jar {params.jar_vdjtools} CalcDiversityStats {input} {wildcards.sample} && mv {wildcards.sample}.diversity.strict.exact.txt {output}"

rule vdjtools_diversity_all:
     input:
        expand(config["output_folder"] + "MiXCR/converted.{sample}.txt",sample=samples["sample_ID"])



