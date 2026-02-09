#code to generate figure 3c Hymod and SACSMA

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

load(paste0(folder,"/Mat_MeanBest"))
load(paste0(folder,"/textMat_MeanBest"))
load(paste0(folder,"/Mat_MeanWorst"))
load(paste0(folder,"/textMat_MeanWorst"))

Diff_Hymod<- Mat_MeanWorst-Mat_MeanBest; rm(Mat_MeanWorst); rm(Mat_MeanBest)

Diff_Hymod_hr<- Diff_Hymod/3600
Diff_Hymod_day<- Diff_Hymod_hr/24
Diff_Hymod_yr<- Diff_Hymod_day/365

Timescale_Diff_Hymod<- matrix(NA,nrow=nrow(Diff_Hymod),ncol=ncol(Diff_Hymod))
for(i in 1:nrow(Diff_Hymod)){
  for(j in 1:ncol(Diff_Hymod)){
    if(!is.na(Diff_Hymod[i,j])){
      if(Diff_Hymod[i,j]<60) Timescale_Diff_Hymod[i,j]<- "second"
      if(Diff_Hymod[i,j]>=60 & Diff_Hymod[i,j]<3600) Timescale_Diff_Hymod[i,j]<- "minute"
      if(Diff_Hymod_hr[i,j]>=1 & Diff_Hymod_hr[i,j]<24) Timescale_Diff_Hymod[i,j]<- "hour"
      if(Diff_Hymod_day[i,j]>=1 & Diff_Hymod_day[i,j]<7) Timescale_Diff_Hymod[i,j]<- "day"
      if(Diff_Hymod_day[i,j]>=7 & Diff_Hymod_day[i,j]<28) Timescale_Diff_Hymod[i,j]<- "week"
      if(Diff_Hymod_day[i,j]>=28 & Diff_Hymod_day[i,j]<365) Timescale_Diff_Hymod[i,j]<- "month"
      if(Diff_Hymod_yr[i,j]>=1 & Diff_Hymod_yr[i,j]<10) Timescale_Diff_Hymod[i,j]<- "year"
      if(Diff_Hymod_yr[i,j]>=10) Timescale_Diff_Hymod[i,j]<- "decade"
    }
  }
}

rownames(Timescale_Diff_Hymod) <- tested_D_num
colnames(Timescale_Diff_Hymod) <- eval_time_lab

################################################################################
#SACSMA10 results
source("0_librarySACSMA10par.R")
folder<- paste0(folderpath,"SacSma10")

tested_D_num <- c(10)
tested_D <- c("10D")

load(paste0(folder,"/Mat_MeanBest"))
load(paste0(folder,"/textMat_MeanBest"))
load(paste0(folder,"/Mat_MeanWorst"))
load(paste0(folder,"/textMat_MeanWorst"))

Diff_SACSMA10<- Mat_MeanWorst-Mat_MeanBest; rm(Mat_MeanWorst); rm(Mat_MeanBest)

Diff_SACSMA10_hr<- Diff_SACSMA10/3600
Diff_SACSMA10_day<- Diff_SACSMA10_hr/24
Diff_SACSMA10_yr<- Diff_SACSMA10_day/365

Timescale_Diff_SACSMA10<- matrix(NA,nrow=nrow(Diff_SACSMA10),ncol=ncol(Diff_SACSMA10))
for(i in 1:nrow(Diff_SACSMA10)){
  for(j in 1:ncol(Diff_SACSMA10)){
    if(!is.na(Diff_SACSMA10[i,j])){
      if(Diff_SACSMA10[i,j]<60) Timescale_Diff_SACSMA10[i,j]<- "second"
      if(Diff_SACSMA10[i,j]>=60 & Diff_SACSMA10[i,j]<3600) Timescale_Diff_SACSMA10[i,j]<- "minute"
      if(Diff_SACSMA10_hr[i,j]>=1 & Diff_SACSMA10_hr[i,j]<24) Timescale_Diff_SACSMA10[i,j]<- "hour"
      if(Diff_SACSMA10_day[i,j]>=1 & Diff_SACSMA10_day[i,j]<7) Timescale_Diff_SACSMA10[i,j]<- "day"
      if(Diff_SACSMA10_day[i,j]>=7 & Diff_SACSMA10_day[i,j]<28) Timescale_Diff_SACSMA10[i,j]<- "week"
      if(Diff_SACSMA10_day[i,j]>=28 & Diff_SACSMA10_day[i,j]<365) Timescale_Diff_SACSMA10[i,j]<- "month"
      if(Diff_SACSMA10_yr[i,j]>=1 & Diff_SACSMA10_yr[i,j]<10) Timescale_Diff_SACSMA10[i,j]<- "year"
      if(Diff_SACSMA10_yr[i,j]>=10) Timescale_Diff_SACSMA10[i,j]<- "decade"
    }
  }
}

rownames(Timescale_Diff_SACSMA10) <- tested_D_num
colnames(Timescale_Diff_SACSMA10) <- eval_time_lab

################################################################################
#plot results

Timescale_Diff_Hymod_SACSMA10<- rbind(Timescale_Diff_Hymod,Timescale_Diff_SACSMA10)

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Fig3c_Timescale_Diff_Hymod_SACSMA10.pdf",width = 12,height = 3.5)
par(mar=c(5,5,2.6,6))
plot(Timescale_Diff_Hymod_SACSMA10[nrow(Timescale_Diff_Hymod_SACSMA10):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()
