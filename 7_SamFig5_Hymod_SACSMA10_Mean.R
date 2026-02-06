#code to generate new figure 5c Hymod and SACSMA

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

if(dir.exists("Sam_Figures")==FALSE) dir.create("Sam_Figures")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_M <- c("Sobol","Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")


################################################################################
#Hymod results
source("0_libraryHymod.R")
folder<- paste0(folderpath,"Hymod")

tested_D_num <- c(5)
tested_D <- c("5D")

load(paste0(folder,"/Summary_Time_Sobol"))
load(paste0(folder,"/Summary_Time_AKMCS"))
load(paste0(folder,"/Summary_Time_BASS"))
load(paste0(folder,"/Summary_Time_Kriging"))

Mean_Time_Best_Hymod <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
textMat_meanBest_Hymod <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    textMat_meanBest_Hymod[i,j]<- tested_M[which.min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                                 Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))]
    Mean_Time_Best_Hymod[i,j]<- min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))
    
  }
}

Mean_Time_Best_Hymod_hr<- Mean_Time_Best_Hymod/3600
Mean_Time_Best_Hymod_day<- Mean_Time_Best_Hymod_hr/24
Mean_Time_Best_Hymod_yr<- Mean_Time_Best_Hymod_day/365

Timescale_MeanBest_Hymod<- matrix(NA,nrow=nrow(Mean_Time_Best_Hymod),ncol=ncol(Mean_Time_Best_Hymod))
for(i in 1:nrow(Mean_Time_Best_Hymod)){
  for(j in 1:ncol(Mean_Time_Best_Hymod)){
    if(!is.na(Mean_Time_Best_Hymod[i,j])){
      if(Mean_Time_Best_Hymod[i,j]<60) Timescale_MeanBest_Hymod[i,j]<- "second"
      if(Mean_Time_Best_Hymod[i,j]>=60 & Mean_Time_Best_Hymod[i,j]<3600) Timescale_MeanBest_Hymod[i,j]<- "minute"
      if(Mean_Time_Best_Hymod_hr[i,j]>=1 & Mean_Time_Best_Hymod_hr[i,j]<24) Timescale_MeanBest_Hymod[i,j]<- "hour"
      if(Mean_Time_Best_Hymod_day[i,j]>=1 & Mean_Time_Best_Hymod_day[i,j]<7) Timescale_MeanBest_Hymod[i,j]<- "day"
      if(Mean_Time_Best_Hymod_day[i,j]>=7 & Mean_Time_Best_Hymod_day[i,j]<28) Timescale_MeanBest_Hymod[i,j]<- "week"
      if(Mean_Time_Best_Hymod_day[i,j]>=28 & Mean_Time_Best_Hymod_day[i,j]<365) Timescale_MeanBest_Hymod[i,j]<- "month"
      if(Mean_Time_Best_Hymod_yr[i,j]>=1 & Mean_Time_Best_Hymod_yr[i,j]<10) Timescale_MeanBest_Hymod[i,j]<- "year"
      if(Mean_Time_Best_Hymod_yr[i,j]>=10) Timescale_MeanBest_Hymod[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MeanBest_Hymod) <- tested_D_num
colnames(Timescale_MeanBest_Hymod) <- eval_time_lab

rownames(textMat_meanBest_Hymod) <- tested_D_num
colnames(textMat_meanBest_Hymod) <- eval_time_lab
################################################################################
#SACSMA10 results
source("0_librarySACSMA10par.R")
folder<- paste0(folderpath,"SacSma10")

tested_D_num <- c(10)
tested_D <- c("10D")

load(paste0(folder,"/Summary_Time_Sobol"))
load(paste0(folder,"/Summary_Time_AKMCS"))
load(paste0(folder,"/Summary_Time_BASS"))
load(paste0(folder,"/Summary_Time_Kriging"))

Mean_Time_Best_SACSMA10 <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
textMat_meanBest_SACSMA10 <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    textMat_meanBest_SACSMA10[i,j]<- tested_M[which.min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                                       Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))]
    Mean_Time_Best_SACSMA10[i,j]<- min(c(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                                      Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j]))
    
  }
}

Mean_Time_Best_SACSMA10_hr<- Mean_Time_Best_SACSMA10/3600
Mean_Time_Best_SACSMA10_day<- Mean_Time_Best_SACSMA10_hr/24
Mean_Time_Best_SACSMA10_yr<- Mean_Time_Best_SACSMA10_day/365

Timescale_MeanBest_SACSMA10<- matrix(NA,nrow=nrow(Mean_Time_Best_SACSMA10),ncol=ncol(Mean_Time_Best_SACSMA10))
for(i in 1:nrow(Mean_Time_Best_SACSMA10)){
  for(j in 1:ncol(Mean_Time_Best_SACSMA10)){
    if(!is.na(Mean_Time_Best_SACSMA10[i,j])){
      if(Mean_Time_Best_SACSMA10[i,j]<60) Timescale_MeanBest_SACSMA10[i,j]<- "second"
      if(Mean_Time_Best_SACSMA10[i,j]>=60 & Mean_Time_Best_SACSMA10[i,j]<3600) Timescale_MeanBest_SACSMA10[i,j]<- "minute"
      if(Mean_Time_Best_SACSMA10_hr[i,j]>=1 & Mean_Time_Best_SACSMA10_hr[i,j]<24) Timescale_MeanBest_SACSMA10[i,j]<- "hour"
      if(Mean_Time_Best_SACSMA10_day[i,j]>=1 & Mean_Time_Best_SACSMA10_day[i,j]<7) Timescale_MeanBest_SACSMA10[i,j]<- "day"
      if(Mean_Time_Best_SACSMA10_day[i,j]>=7 & Mean_Time_Best_SACSMA10_day[i,j]<28) Timescale_MeanBest_SACSMA10[i,j]<- "week"
      if(Mean_Time_Best_SACSMA10_day[i,j]>=28 & Mean_Time_Best_SACSMA10_day[i,j]<365) Timescale_MeanBest_SACSMA10[i,j]<- "month"
      if(Mean_Time_Best_SACSMA10_yr[i,j]>=1 & Mean_Time_Best_SACSMA10_yr[i,j]<10) Timescale_MeanBest_SACSMA10[i,j]<- "year"
      if(Mean_Time_Best_SACSMA10_yr[i,j]>=10) Timescale_MeanBest_SACSMA10[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MeanBest_SACSMA10) <- tested_D_num
colnames(Timescale_MeanBest_SACSMA10) <- eval_time_lab

rownames(textMat_meanBest_SACSMA10) <- tested_D_num
colnames(textMat_meanBest_SACSMA10) <- eval_time_lab

################################################################################
#plot results

Timescale_MeanBest_Hymod_SACSMA10<- rbind(Timescale_MeanBest_Hymod,Timescale_MeanBest_SACSMA10)

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MeanBest_Hymod_SACSMA10.pdf",width = 12,height = 3.5)
par(mar=c(5,5,2.6,6))
plot(Timescale_MeanBest_Hymod_SACSMA10[nrow(Timescale_MeanBest_Hymod_SACSMA10):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

textMat_meanBest_Hymod_SACSMA10<- rbind(textMat_meanBest_Hymod,textMat_meanBest_SACSMA10)

#Figure showing which approach is fastest on average where we know
rownames(textMat_meanBest_Hymod) <- tested_D_num
colnames(textMat_meanBest_Hymod) <- eval_time_lab
cols<-c("purple","orange","maroon","turquoise","white")

pdf(file = "./Sam_Figures/MeanFastestAcrossAllSeeds_Hymod_SACSMA10.pdf",width = 12,height = 3.5)
par(mar=c(5,5,2.6,6))
plot(textMat_meanBest_Hymod_SACSMA10[nrow(textMat_meanBest_Hymod_SACSMA10):1, ],breaks = c("Sobol","AKMCS",
                                                             "BASS","Kriging","None"),
     xlab="Time of single run",ylab="Number of parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()
