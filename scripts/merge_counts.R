#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

setwd(args[1])
Count_list<-system("ls", intern=T)
Count_list<-Count_list[grep("_HTseqCount.txt", Count_list)]


i=1
tmp1<-read.table(file=Count_list[i], sep="\t", header=F)
Uni_ENSGID<-tmp1[,1]

Data_matrix<-matrix(data=0, ncol=length(Count_list), nrow=length(Uni_ENSGID))
row.names(Data_matrix)<-Uni_ENSGID
colnames(Data_matrix)<-SampleNames<-gsub("_HTseqCount.txt","",Count_list)

for (i in 1:length(Count_list)){
  tmp<-read.table(file=Count_list[i], sep="\t", header=F)
  tmp_index<-match(row.names(Data_matrix), tmp[,1])
  Data_matrix[,i]<-tmp[tmp_index,2]
}


write.table(Data_matrix, file=paste0(args[1],"/Count_matrix_HTseq.txt"), sep="\t", quote=F)
