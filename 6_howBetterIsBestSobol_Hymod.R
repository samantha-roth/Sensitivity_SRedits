# how different is the "best" for all seeds from the other approaches where it is best?

rm(list=ls())
graphics.off()

source("0_library.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- 5
tested_D <- "5D"
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")


load(paste0("./Ranking_Data/Hymod/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Hymod/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Hymod/Summary_Time_Kriging"))
load(paste0("./Ranking_Data/Hymod/Summary_Time_AKMCS"))

load("./Ranking_Data/Hymod/textMat_maxSobol")

################################################################################
whichSobolBest<- which(textMat_maxSobol=="Sobol",arr.ind=FALSE)
whichSobolBestArr<- which(textMat_maxSobol=="Sobol",arr.ind=TRUE)

D_Sobol_Best<- tested_D[whichSobolBestArr[,1]]
time_Sobol_Best<- eval_time_lab[whichSobolBestArr[,2]]

save(whichSobolBest,whichSobolBestArr,D_Sobol_Best,time_Sobol_Best,
     file="./Ranking_Data/Hymod/whichSobolBest")

dim_time_df<- data.frame("dim"=D_Sobol_Best, "time"=time_Sobol_Best)

Mean_Diff_BASS<- rep(NA, length(whichSobolBest))
Mean_Diff_Kriging<- rep(NA, length(whichSobolBest))
Mean_Diff_AKMCS<- rep(NA, length(whichSobolBest))

Mean_Diff_BASS<- Mean_Time_BASS[whichSobolBest]-Mean_Time_Sobol[whichSobolBest]
Mean_Diff_Kriging<- Mean_Time_Kriging[whichSobolBest]-Mean_Time_Sobol[whichSobolBest]
Mean_Diff_AKMCS<- Mean_Time_AKMCS[whichSobolBest]-Mean_Time_Sobol[whichSobolBest]

Mean_Time_Sobol_Best<- Mean_Time_Sobol[whichSobolBest]

Mean_Diff_Min<- rep(NA,length(whichSobolBest))
min_method<- rep(NA,length(whichSobolBest))
for(i in 1:length(whichSobolBest)){
  Mean_Diff_Min[i]<- min(Mean_Diff_AKMCS[i],Mean_Diff_BASS[i],Mean_Diff_Kriging[i])
  if(Mean_Diff_Min[i]==Mean_Diff_BASS[i]) min_method[i]<- "BASS"
  if(Mean_Diff_Min[i]==Mean_Diff_Kriging[i]) min_method[i]<- "Kriging"
  if(Mean_Diff_Min[i]==Mean_Diff_AKMCS[i]) min_method[i]<- "AKMCS"
}


pct_diff_min<- Mean_Diff_Min/Mean_Time_Sobol_Best
pct_diff_min

Mean_Time_Sobol_Best_min<- Mean_Time_Sobol_Best/60
Mean_Time_Sobol_Best_hr<- Mean_Time_Sobol_Best/3600
Mean_Time_Sobol_Best_day<- Mean_Time_Sobol_Best_hr/24
Mean_Time_Sobol_Best_yr<- Mean_Time_Sobol_Best_day/365

Mean_Time_Sobol_Best_hr

Mean_Diff_Min_min<- Mean_Diff_Min/60
Mean_Diff_Min_hr<- Mean_Diff_Min/3600
Mean_Diff_Min_day<- Mean_Diff_Min_hr/24
Mean_Diff_Min_yr<- Mean_Diff_Min_day/365

#1ms

#10ms

#.1s

#1s

for(i in 1:length(whichSobolBest)){
  print(paste0(D_Sobol_Best[i],", ",time_Sobol_Best[i]))
  print(paste0("Sobol mean in minutes: ", Mean_Time_Sobol[whichSobolBest[i]]/60))
  print(paste0("BASS mean in minutes: ", Mean_Time_BASS[whichSobolBest[i]]/60))
  print(paste0("Kriging mean in minutes: ", Mean_Time_Kriging[whichSobolBest[i]]/60))
  print(paste0("AKMCS mean in minutes: ", Mean_Time_AKMCS[whichSobolBest[i]]/60))
}


for(i in 1:length(whichSobolBest)){
  print(paste0(D_Sobol_Best[i],", ",time_Sobol_Best[i]))
    print(paste0("Kriging in minutes: ",Min_Time_Kriging[whichSobolBest[i]]/60,", ",
                 Mean_Time_Kriging[whichSobolBest[i]]/60,", ",
                 Max_Time_Kriging[whichSobolBest[i]]/60))
    print(paste0("BASS in minutes: ",Min_Time_BASS[whichSobolBest[i]]/60,", ",
                 Mean_Time_BASS[whichSobolBest[i]]/60,", ",
                 Max_Time_BASS[whichSobolBest[i]]/60))
    print(paste0("AKMCS in minutes: ",Min_Time_AKMCS[whichSobolBest[i]]/60,", ",
                 Mean_Time_AKMCS[whichSobolBest[i]]/60,", ",
                 Max_Time_AKMCS[whichSobolBest[i]]/60))
    print(paste0("Sobol in minutes: ",Min_Time_Sobol[whichSobolBest[i]]/60,", ",
                 Mean_Time_Sobol[whichSobolBest[i]]/60,", ",
                 Max_Time_Sobol[whichSobolBest[i]]/60))
}