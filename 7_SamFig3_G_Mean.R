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

load("./Ranking_Data/Time_Sobol_30D_allseeds")
load("./Ranking_Data/Time_AKMCS_30D_allseeds")
load("./Ranking_Data/Time_BASS_30D_allseeds")
load("./Ranking_Data/Time_Kriging_30D_allseeds")

Min_30D_Sobol<- rep(NA,length(tested_eval_time))
Mean_30D_Sobol<- rep(NA,length(tested_eval_time))
Max_30D_Sobol<- rep(NA,length(tested_eval_time))

Min_30D_AKMCS<- rep(NA,length(tested_eval_time))
Mean_30D_AKMCS<- rep(NA,length(tested_eval_time))
Max_30D_AKMCS<- rep(NA,length(tested_eval_time))

Min_30D_BASS<- rep(NA,length(tested_eval_time))
Mean_30D_BASS<- rep(NA,length(tested_eval_time))
Max_30D_BASS<- rep(NA,length(tested_eval_time))

Min_30D_Kriging<- rep(NA,length(tested_eval_time))
Mean_30D_Kriging<- rep(NA,length(tested_eval_time))
Max_30D_Kriging<- rep(NA,length(tested_eval_time))

for(j in 1:length(tested_eval_time)){
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


load("./Ranking_Data/Mat_MeanBest")
load("./Ranking_Data/Mat_MeanWorst")

Mean_Diff<- Mat_MeanWorst-Mat_MeanBest
Mean_Diff[length(tested_D),]<- NA

# for(j in 1:length(tested_eval_time)){
#   if(Mean_30D_Sobol[j]<min(c(Mean_30D_AKMCS[j],Mean_30D_BASS[j],Mean_30D_Kriging[j]))){
#     Mean_Diff[length(tested_D),j]<- max(c(Mean_30D_AKMCS[j],Mean_30D_BASS[j],Mean_30D_Kriging[j]))-Mean_30D_Sobol[j]
#   }
# }

Mean_Diff_hr<- Mean_Diff/3600
Mean_Diff_day<- Mean_Diff_hr/24
Mean_Diff_yr<- Mean_Diff_day/365

Timescale_Diff<- matrix(NA,nrow=nrow(Mean_Diff),ncol=ncol(Mean_Diff))
for(i in 1:(nrow(Mean_Diff)-1)){
  for(j in 1:ncol(Mean_Diff)){
    if(Mean_Diff[i,j]<60) Timescale_Diff[i,j]<- "second"
    if(Mean_Diff[i,j]>=60 & Mean_Diff[i,j]<3600) Timescale_Diff[i,j]<- "minute"
    if(Mean_Diff_hr[i,j]>=1 & Mean_Diff_hr[i,j]<24) Timescale_Diff[i,j]<- "hour"
    if(Mean_Diff_day[i,j]>=1 & Mean_Diff_day[i,j]<7) Timescale_Diff[i,j]<- "day"
    if(Mean_Diff_day[i,j]>=7 & Mean_Diff_day[i,j]<28) Timescale_Diff[i,j]<- "week"
    if(Mean_Diff_day[i,j]>=28 & Mean_Diff_day[i,j]<365) Timescale_Diff[i,j]<- "month"
    if(Mean_Diff_yr[i,j]>=1 & Mean_Diff_yr[i,j]<10) Timescale_Diff[i,j]<- "year"
    if(Mean_Diff_yr[i,j]>=10) Timescale_Diff[i,j]<- "decade"
  }
}

rownames(Timescale_Diff) <- tested_D_num
colnames(Timescale_Diff) <- eval_time_lab

Timescale_Diff[nrow(Timescale_Diff),]<- "NA"
# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxMean-MinMean.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_Diff[nrow(Timescale_Diff):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()
