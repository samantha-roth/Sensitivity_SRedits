#code to generate new figure 3 for Sobol's G function

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
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")


load(paste0("./Ranking_Data/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))

load("./Ranking_Data/Time_Sobol_30D_allseeds")
load("./Ranking_Data/Time_AKMCS_30D_allseeds")
load("./Ranking_Data/Time_BASS_30D_allseeds")
load("./Ranking_Data/Time_Kriging_30D_allseeds")

Min_30D_Sobol<- rep(NA,ncol(Min_Time_Sobol))
Mean_30D_Sobol<- rep(NA,ncol(Min_Time_Sobol))
Max_30D_Sobol<- rep(NA,ncol(Min_Time_Sobol))

Min_30D_AKMCS<- rep(NA,ncol(Min_Time_AKMCS))
Mean_30D_AKMCS<- rep(NA,ncol(Min_Time_AKMCS))
Max_30D_AKMCS<- rep(NA,ncol(Min_Time_AKMCS))

Min_30D_BASS<- rep(NA,ncol(Min_Time_BASS))
Mean_30D_BASS<- rep(NA,ncol(Min_Time_BASS))
Max_30D_BASS<- rep(NA,ncol(Min_Time_BASS))

Min_30D_Kriging<- rep(NA,ncol(Min_Time_Kriging))
Mean_30D_Kriging<- rep(NA,ncol(Min_Time_Kriging))
Max_30D_Kriging<- rep(NA,ncol(Min_Time_Kriging))

for(j in 1:ncol(Min_Time_Sobol)){
  Min_30D_Sobol[j]<- min(Time_Sobol_30D_allseeds[,j])
  Mean_30D_Sobol[j]<- mean(Time_Sobol_30D_allseeds[,j])
  Max_30D_Sobol[j]<- max(Time_Sobol_30D_allseeds[,j])
  
  Min_30D_AKMCS[j]<- min(Time_AKMCS_30D_allseeds[,j])
  Mean_30D_AKMCS[j]<- mean(Time_AKMCS_30D_allseeds[,j])
  Max_30D_AKMCS[j]<- max(Time_AKMCS_30D_allseeds[,j])
  
  Min_30D_BASS[j]<- min(Time_BASS_30D_allseeds[,j])
  Mean_30D_BASS[j]<- mean(Time_BASS_30D_allseeds[,j])
  Max_30D_BASS[j]<- max(Time_BASS_30D_allseeds[,j])
  
  Min_30D_Kriging[j]<- min(Time_Kriging_30D_allseeds[,j])
  Mean_30D_Kriging[j]<- mean(Time_Kriging_30D_allseeds[,j])
  Max_30D_Kriging[j]<- max(Time_Kriging_30D_allseeds[,j])
}


load("./Ranking_Data/textMat_uniformBest")

max_diff<- matrix(NA,nrow=nrow(Min_Time_Sobol),ncol=ncol(Min_Time_Sobol))

for(i in 1:(nrow(Min_Time_Sobol)-1)){
  for(j in 1:ncol(Min_Time_Sobol)){
    max_diff[i,j]<- max(c(Max_Time_Sobol[i,j],Max_Time_AKMCS[i,j],Max_Time_BASS[i,j],Max_Time_Kriging[i,j]))-
      min(c(Min_Time_Sobol[i,j],Min_Time_AKMCS[i,j],Min_Time_BASS[i,j],Min_Time_Kriging[i,j]))
    
  }
}

i= nrow(Min_Time_Sobol)

for(j in 1:ncol(Min_Time_Sobol)){
  max_diff[i,j]<- max(c(Max_30D_Sobol[j],Max_30D_AKMCS[j],Max_30D_BASS[j],Max_30D_Kriging[j]))-
    min(c(Min_30D_Sobol[j],Min_30D_AKMCS[j],Min_30D_BASS[j],Min_30D_Kriging[j]))
  
}

max_diff_hr<- max_diff/3600
max_diff_day<- max_diff_hr/24
max_diff_yr<- max_diff_day/365

Timescale_MaxDiff<- matrix(NA,nrow=nrow(max_diff),ncol=ncol(max_diff))
for(i in 1:nrow(max_diff)){
  for(j in 1:ncol(max_diff)){
    if(max_diff[i,j]<60) Timescale_MaxDiff[i,j]<- "second"
    if(max_diff[i,j]>=60 & max_diff[i,j]<3600) Timescale_MaxDiff[i,j]<- "minute"
    if(max_diff_hr[i,j]>=1 & max_diff_hr[i,j]<24) Timescale_MaxDiff[i,j]<- "hour"
    if(max_diff_day[i,j]>=1 & max_diff_day[i,j]<7) Timescale_MaxDiff[i,j]<- "day"
    if(max_diff_day[i,j]>=7 & max_diff_day[i,j]<28) Timescale_MaxDiff[i,j]<- "week"
    if(max_diff_day[i,j]>=28 & max_diff_day[i,j]<365) Timescale_MaxDiff[i,j]<- "month"
    if(max_diff_yr[i,j]>=1 & max_diff_yr[i,j]<10) Timescale_MaxDiff[i,j]<- "year"
    if(max_diff_yr[i,j]>=10) Timescale_MaxDiff[i,j]<- "decade"
  }
}

rownames(Timescale_MaxDiff) <- tested_D_num
colnames(Timescale_MaxDiff) <- eval_time_lab

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black")
brks<-c("second","minute","hour","day","week","month","year","decade")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff[nrow(Timescale_MaxDiff):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

load("./Ranking_Data/text_bestSeedMod")
Timescale_MaxDiff[which(is.na(text_bestSeedMod))]<- "NA"

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff_UnifBest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff[nrow(Timescale_MaxDiff):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

