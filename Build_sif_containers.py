# build containers from docker images when not present
# default containers listed for the RNAseq pipeline v2.1 (2306)

import os

if __name__ == "__main__":
  print("build containers from docker images")
  print("WARING: requires sudo rights")
  
  if (os.path.isfile("sif/fastqc_v0.11.9_cv8.sif")) == (not True):
    os.system("singularity build sif/fastqc_v0.11.9_cv8.sif docker://biocontainers/fastqc:v0.11.9_cv8")
  else:
    print("fastqc_v0.11.9_cv8.sif already present")
  
  if (os.path.isfile("sif/htseq_v2.0.2_quay.sif")) == (not True):
    os.system("singularity build sif/htseq_v2.0.2_quay.sif docker://quay.io/biocontainers/htseq:2.0.2")
  else:
    print("htseq_v2.0.2_quay.sif already present")  
    
  if (os.path.isfile("sif/kallisto_v0.48.0_zlskidmore.sif")) == (not True):
    os.system("singularity build sif/kallisto_v0.48.0_zlskidmore.sif docker://zlskidmore/kallisto:0.48.0")
  else:
    print("kallisto_v0.48.0_zlskidmore.sif already present")  
    
  if (os.path.isfile("sif/multiqc_v1.8_staphb.sif")) == (not True):
    os.system("singularity build sif/multiqc_v1.8_staphb.sif docker://staphb/multiqc:1.8")
  else:
    print("multiqc_v1.8_staphb.sif already present")  

  if (os.path.isfile("sif/ngsderive_v1.2.0_stjudecloud.sif")) == (not True):
    os.system("singularity build sif/ngsderive_v1.2.0_stjudecloud.sif docker://stjudecloud/ngsderive:1.2.0")
  else:
    print("ngsderive_v1.2.0_stjudecloud.sif already present")  

  if (os.path.isfile("sif/samtools_1.9_staphb.sif")) == (not True):
    os.system("singularity build sif/samtools_1.9_staphb.sif docker://staphb/samtools:1.9")
  else:
    print("samtools_1.9_staphb.sif already present")  
    
  if (os.path.isfile("sif/star-aligner_2.7.9a_danielfsribeiro.sif")) == (not True):
    os.system("singularity build sif/star-aligner_2.7.9a_danielfsribeiro.sif docker://danielfsribeiro/star-aligner:2.7.9a")
  else:
    print("star-aligner_2.7.9a_danielfsribeiro.sif already present")  
