#compare fastest on average to standard Sobol' for the polynomial function
#say Sobol' is good enough if the difference is <24 hours

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

source("0_libraryPoly.R")
source("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#load time summaries for standard Sobol
load(paste0("./Ranking_Data/Summary_Time_Sobol"))

#load the mean time for the fastest approach
load("./Ranking_Data/Mat_MeanBest")

SobolMinusBest<- Mean_Time_Sobol-Mat_MeanBest
SobolMinusBest_hrs<- SobolMinusBest/(60^2)
colnames(SobolMinusBest_hrs)<- eval_time_lab
rownames(SobolMinusBest_hrs)<- tested_D

textMat_SobolEnough<- matrix(NA, nrow= length(tested_D), ncol= length(eval_time_lab))
for(i in 1:nrow(textMat_SobolEnough)){
  for(j in 1:ncol(textMat_SobolEnough)){
    if(SobolMinusBest_hrs[i,j]<24) textMat_SobolEnough[i,j]<- "yes"
  }
}

save(textMat_SobolEnough,file="./Ranking_Data/textMat_SobolEnough")

#repeat with the max Sobol time
SobolMinusBest<- Max_Time_Sobol-Mat_MeanBest
SobolMinusBest_hrs<- SobolMinusBest/(60^2)
colnames(SobolMinusBest_hrs)<- eval_time_lab
rownames(SobolMinusBest_hrs)<- tested_D

textMat_SobolMaxEnough<- matrix(NA, nrow= length(tested_D), ncol= length(eval_time_lab))
for(i in 1:nrow(textMat_SobolMaxEnough)){
  for(j in 1:ncol(textMat_SobolMaxEnough)){
    if(SobolMinusBest_hrs[i,j]<24) textMat_SobolMaxEnough[i,j]<- "yes"
  }
}

save(textMat_SobolMaxEnough,file="./Ranking_Data/textMat_SobolMaxEnough")