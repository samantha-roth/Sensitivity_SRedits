#code to generate new figure 5 for Sobol's G function

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

if(dir.exists("Sam_Figures")==FALSE) dir.create("Sam_Figures")

source("0_library.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("AKMCS","BASS","Kriging","Sobol")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#G function results
load(paste0("./Ranking_Data/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))

#best for 30D for the G function
load(paste0("./Ranking_Data/bestFor30D"))

Mean_Time_Best <- matrix(NA,nrow=nrow(Mean_Time_Sobol),ncol=ncol(Mean_Time_Sobol))
textMat_meanBest <- matrix(NA,nrow=nrow(Mean_Time_Sobol),ncol=ncol(Mean_Time_Sobol))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    textMat_meanBest[i,j]<- tested_M[which.min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                                 Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))]
    Mean_Time_Best[i,j]<- min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))
    
  }
}

textMat_meanBest[length(tested_D),]<- bestFor30D
Mean_Time_Best[length(tested_D),which(bestFor30D=="Sobol")]<- Mean_Time_Sobol[length(tested_D),which(bestFor30D=="Sobol")]

Mean_Time_Best_hr<- Mean_Time_Best/3600
Mean_Time_Best_day<- Mean_Time_Best_hr/24
Mean_Time_Best_yr<- Mean_Time_Best_day/365

Timescale_MeanBest<- matrix(NA,nrow=nrow(Mean_Time_Best),ncol=ncol(Mean_Time_Best))
for(i in 1:nrow(Mean_Time_Best)){
  for(j in 1:ncol(Mean_Time_Best)){
    if(!is.na(Mean_Time_Best[i,j])){
      if(Mean_Time_Best[i,j]<60) Timescale_MeanBest[i,j]<- "second"
      if(Mean_Time_Best[i,j]>=60 & Mean_Time_Best[i,j]<3600) Timescale_MeanBest[i,j]<- "minute"
      if(Mean_Time_Best_hr[i,j]>=1 & Mean_Time_Best_hr[i,j]<24) Timescale_MeanBest[i,j]<- "hour"
      if(Mean_Time_Best_day[i,j]>=1 & Mean_Time_Best_day[i,j]<7) Timescale_MeanBest[i,j]<- "day"
      if(Mean_Time_Best_day[i,j]>=7 & Mean_Time_Best_day[i,j]<28) Timescale_MeanBest[i,j]<- "week"
      if(Mean_Time_Best_day[i,j]>=28 & Mean_Time_Best_day[i,j]<365) Timescale_MeanBest[i,j]<- "month"
      if(Mean_Time_Best_yr[i,j]>=1 & Mean_Time_Best_yr[i,j]<10) Timescale_MeanBest[i,j]<- "year"
      if(Mean_Time_Best_yr[i,j]>=10) Timescale_MeanBest[i,j]<- "decade"
    }
  }
}

textMat_meanBest[which(is.na(textMat_meanBest))]<- "NA"
textMat_meanBest[which(is.na(Mean_Time_Best))]<- "NA"


#Figure 5 a
rownames(Timescale_MeanBest) <- tested_D_num
colnames(Timescale_MeanBest) <- eval_time_lab

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MeanBest_G.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MeanBest[nrow(Timescale_MeanBest):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

#Figure showing which approach is fastest on average where we know
rownames(textMat_meanBest) <- tested_D_num
colnames(textMat_meanBest) <- eval_time_lab
cols<-c("purple","orange","maroon","turquoise","white")

pdf(file = "./Sam_Figures/MeanFastestAcrossAllSeeds_G.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(textMat_meanBest[nrow(textMat_meanBest):1, ],breaks = c("Sobol","AKMCS","BASS","Kriging","None"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()
