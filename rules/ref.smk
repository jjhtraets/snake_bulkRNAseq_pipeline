rule get_genome:
    output:
        config["ensbl"]["reference_folder"]+"genome.fasta"
    params:
        species=config["ensbl"]["species"],
        datatype=config["ensbl"]["type"],
        build=config["ensbl"]["build"],
        release=config["ensbl"]["release"]
    log:
        "logs/get_genome.log"
    cache: True  # save space and time with between workflow caching (see docs)
    wrapper:
        "v1.1.0/bio/reference/ensembl-sequence"

rule get_annotation:
    output:
        config["ensbl"]["reference_folder"]+"/annotation.gtf"
    params:
        species=config["ensbl"]["species"],
        release=config["ensbl"]["release"],
        build=config["ensbl"]["build"],
        fmt="gtf",
        flavor="" # optional, e.g. chr_patch_hapl_scaff, see Ensembl FTP.
    log:
        "logs/get_annotation.log"
    cache: True  # save space and time with between workflow caching (see docs)
    wrapper:
        "v1.1.0/bio/reference/ensembl-annotation"
