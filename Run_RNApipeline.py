#                         bulk RNAseq snakemake pipeline tumor/normal                          #
#                              ### script to run RNA pipeline ###                              #
# RNAseq data
# paired/single
# counts and expression (TPMs)
# Singularity

# run script for pre-flight checks
# requires Anaconda version of python

import sys
import subprocess
import argparse
import os
import yaml
import pandas as pd
import logging
from datetime import datetime

# config file location fixed
def load_yaml():
    with open("./config/config.yaml", "r") as stream:
        try:
            safe_config = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return safe_config

def check_mode_config_yaml():
    mode_config = ", ".join(key for key, value in yaml_config["run_modes"].items() if value == True)
    return mode_config

def check_sample_file():
    if os.path.exists(yaml_config["samples"]):
        with open(yaml_config["samples"], "r") as file:
            header = file.readline().strip()
            if "sample_ID" in header:
                return "OK"
            else:
                return "sample_ID column name is missing!"
    else:
        return "sample file missing!"

def check_path_format():
    if yaml_config["input"][-1] != "/":
        yaml_config["input"] = yaml_config["input"]+"/"
    if yaml_config["output"][-1] != "/":
        yaml_config["output"] = yaml_config["output"]+"/"

def check_fastq_files():
    samples = pd.read_table(yaml_config["samples"])
    sample_ids = list(samples["sample_ID"])
    sample_ids_loc = [yaml_config["input"]+i+yaml_config["read_name"]["R1"]+".fastq.gz" for i in sample_ids]
    if all(os.path.exists(file_path) for file_path in sample_ids_loc):
        sample_ids_loc = [yaml_config["input"]+i+yaml_config["read_name"]["R2"]+".fastq.gz" for i in sample_ids]
        if all(os.path.exists(file_path) for file_path in sample_ids_loc):
          config["reads"] = "paired"
          return "OK"
        else:
          config["reads"] = "single"
          return "OK"
    else:
        return "fastq files not found"

def kallisto_strandedness():
    if config["strandedness"] == "yes":
        strand_kallisto = "--fr-stranded"
    if config["strandedness"] == "reverse":
        strand_kallisto = "--rf-stranded"
    if config["strandedness"] == "no":
        strand_kallisto = ""
    return strand_kallisto
  
def rsem_strandedness():
    if config["strandedness"] == "yes":
        strand_rsem = "forward"
    if config["strandedness"] == "reverse":
        strand_rsem = "reverse"
    if config["strandedness"] == "no":
        strand_rsem = "none"
    return strand_rsem

def write_config_file():
    to_write = {"output_folder":yaml_config["output"],"input_folder":yaml_config["input"],"bam_to_fastq_r":config["bam"],"reads":config["reads"],"strandedness":config["strandedness"],"kallisto_strand":kallisto_info,"rsem_strand":rsem_info}
    with open("./var/config_user.yaml", "w") as file:
        yaml.dump(to_write, file)

# run snakemakepipeline with OS command based on user input
def run_snakemake(yaml_config,config):
    # prepare bind volumes
    bind_d1 = yaml_config["STAR"]["reference"]
    bind_d1 = bind_d1.split("/")
    bind_d1.pop()
    bind_d1 = "/".join(bind_d1)
    bind_d2 = yaml_config["output"]
    bind_d3 = yaml_config["input"]

    log.info("bind singularity:")
    log.info(bind_d1)
    log.info(bind_d2)
    log.info(bind_d3)

    logging.shutdown()
    
    # save log and config files to output folder
    log_config = bind_d2+"/logs/"+file_path[:-4]
    CHECK_FOLDER = os.path.isdir(log_config)
    if not CHECK_FOLDER:
        os.makedirs(log_config)
    os.system("mv " + file_path + " " + log_config + "/" + file_path)
    os.system("cp config/config.yaml " + log_config + "/")
    os.system("cp var/config_user.yaml " + log_config + "/")

    if yaml_config["run_modes"]["kallisto"] == True and yaml_config["run_modes"]["RSEM"] == False:
        bind_d4 = yaml_config["kallisto"]["reference"]
        bind_d4 = bind_d4.split("/")
        bind_d4.pop()
        bind_d4 = "/".join(bind_d4)
        os.system('snakemake --use-conda --use-singularity --singularity-args "-B ' + bind_d1 + ' -B ' + bind_d2 + ' -B ' + bind_d3 + ' -B ' + bind_d4 + ' " --cores '  + str(config["cores"]) + ' ' + str(yaml_config["snakemake_arg"]))
    if yaml_config["run_modes"]["kallisto"] == False and yaml_config["run_modes"]["RSEM"] == True:
        bind_d4 = yaml_config["RSEM"]["reference"]
        bind_d4 = bind_d4.split("/")
        bind_d4.pop()
        bind_d4 = "/".join(bind_d4)
        print(bind_d1)
        print(bind_d2)
        print(bind_d3)
        print(bind_d4)
        os.system('snakemake --use-conda --use-singularity --singularity-args "-B ' + bind_d1 + ' -B ' + bind_d2 + ' -B ' + bind_d3 + ' -B ' + bind_d4 + ' " --cores '  + str(config["cores"]) + ' ' + str(yaml_config["snakemake_arg"]))
    if yaml_config["run_modes"]["RSEM"] == True and yaml_config["run_modes"]["kallisto"] == True:
        bind_d4 = yaml_config["kallisto"]["reference"]
        bind_d4 = bind_d4.split("/")
        bind_d4.pop()
        bind_d4 = "/".join(bind_d4)
        bind_d5 = yaml_config["RSEM"]["reference"]
        bind_d5 = bind_d5.split("/")
        bind_d5.pop()
        bind_d5 = "/".join(bind_d5)
        os.system('snakemake --use-conda --use-singularity --singularity-args "-B ' + bind_d1 + ' -B ' + bind_d2 + ' -B ' + bind_d3 + ' -B ' + bind_d4 + ' -B ' + bind_d5 + ' " --cores '  + str(config["cores"]) + ' ' + str(yaml_config["snakemake_arg"]))
    if yaml_config["run_modes"]["RSEM"] == False and yaml_config["run_modes"]["kallisto"] == False:
        os.system('snakemake --use-conda --use-singularity --singularity-args "-B ' + bind_d1 + ' -B ' + bind_d2 + ' -B ' + bind_d3 + ' " --cores ' + str(config["cores"]) + ' ' + str(yaml_config["snakemake_arg"]))




if __name__ == "__main__":
  # prepare logging, stdout and log file
  now = datetime.now()
  file_path = now.strftime("%Y-%m-%d_%H:%M:%S.log")
  print(file_path)

  log = logging.getLogger()
  logFormatter = logging.Formatter("%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s]  %(message)s")
  log.setLevel(logging.DEBUG)

  fh = logging.FileHandler(file_path)
  fh.setFormatter(logFormatter)
  log.addHandler(fh)

  ch = logging.StreamHandler()
  ch.setFormatter(logFormatter)
  log.addHandler(ch)

  # banner
  os.system("cat banner_cmd.txt")

  # TODO: add slurm!

  parser = argparse.ArgumentParser(description="Snakemake bulk RNAseq - Pipeline",
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("-c", "--cores",default=1, help="Number of cores to be used (int)")
  parser.add_argument("-b", "--bam",default="False", help="Start with bam files as input (default: False)")
  parser.add_argument("-s", "--strandedness",default="unknown", help="Strandedness (forward or reverse or unknown)",choices={"yes","no","reverse","unknown"})
  args = parser.parse_args()
  config = vars(args)

  yaml_config = load_yaml()
  check_path_format()
  
  # check if fastq files exist
  if config["bam"] == "False":
      check_fastq_return = check_fastq_files()
      log.info("Fastq files: " + str(check_fastq_return))
  
  # print input user
  log.info("Input folder (fastqs):" + yaml_config["input"])
  log.info("Output folder:" + yaml_config["output"])
  log.info("Nr of cores: " + str(config["cores"]))
  log.info("Reads: " + str(config["reads"]))
  log.info("Input bam files: " + str(config["bam"]))
  log.info("Strandedness: " + str(config["strandedness"]))

  # requires essential info
  if yaml_config["run_modes"]["counts"] == True and config["strandedness"] == "unknown":
    log.info("error: strandedness unknown, cannot run Counts (run QCs to determine)")
    sys.exit("set 'counts' as false, or add correct strandedness")
  if yaml_config["run_modes"]["kallisto"] == True and config["strandedness"] == "unknown":
    log.info("error: strandedness unknown, cannot run TPMs (run QCs to determine)")
    sys.exit("set 'TPMs' as false, or add correct strandedness")
  if yaml_config["run_modes"]["mixcr"] == True and config["strandedness"] == "unknown":
    log.info("error: strandedness unknown, cannot run TPMs (run QCs to determine)")
    sys.exit("set 'TPMs' as false, or add correct strandedness")

  if yaml_config["run_modes"]["kallisto"] == True:
    kallisto_info = kallisto_strandedness()
  else:
    kallisto_info = ""
  
  if yaml_config["run_modes"]["RSEM"] == True:
    rsem_info = rsem_strandedness()
  else:
    rsem_info = ""
  
  # check run modes
  run_modes_yaml = check_mode_config_yaml()
  log.info("Run mode: " + str(run_modes_yaml))

  # general checks on yaml file
  check_samples_return = check_sample_file()
  log.info("Sample file: " + str(check_samples_return))

  log.info("Additional arguments for Snakemake: " + str(yaml_config["snakemake_arg"]))

  # ask user to continue
  startRun = True
  if len(str(check_fastq_return)+str(check_samples_return)) ==  4:
    while startRun:
        var = input("Do you want to continue with the current settings? (y/n): ")
        if var != 'y' and var != 'n':
            print("Sorry, I didn't catch that!")
        else:
            startRun = False

    if var == "y":
        write_config_file()
        run_snakemake(yaml_config,config)
    elif var == "n":
        sys.exit("Change config/config.yaml file first before rerunning")
  else:
    sys.exit("Error in input, check paths. Exiting.")
