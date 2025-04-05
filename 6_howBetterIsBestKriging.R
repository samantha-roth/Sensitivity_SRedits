# how different is the "best" for all seeds from the other approaches where it is best?

rm(list=ls())
graphics.off()

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
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))

load("./Ranking_Data/textMat_maxKriging")

################################################################################
whichKrigingBest<- which(textMat_maxKriging=="Kriging",arr.ind=FALSE)
whichKrigingBestArr<- which(textMat_maxKriging=="Kriging",arr.ind=TRUE)

D_Kriging_Best<- tested_D[whichKrigingBestArr[,1]]
time_Kriging_Best<- eval_time_lab[whichKrigingBestArr[,2]]

save(whichKrigingBest,whichKrigingBestArr,D_Kriging_Best,time_Kriging_Best,
     file="./Ranking_Data/whichKrigingBest")

dim_time_df<- data.frame("dim"=D_Kriging_Best, "time"=time_Kriging_Best)

for(i in 1:length(whichKrigingBest)){
  print(paste0(D_Kriging_Best[i],", ",time_Kriging_Best[i]))
  print(paste0("Kriging mean in hours: ", Mean_Time_Kriging[whichKrigingBest[i]]/3600))
  print(paste0("BASS mean in hours: ", Mean_Time_BASS[whichKrigingBest[i]]/3600))
  print(paste0("AKMCS mean in hours: ", Mean_Time_AKMCS[whichKrigingBest[i]]/3600))
  print(paste0("Sobol mean in hours: ", Mean_Time_Sobol[whichKrigingBest[i]]/3600))
}

#"10D, 1min": Kriging saves about 1.5 hours compared to AKMCS on average, 
#10 hours compared to BASS, and 125 hours compared to Kriging

Mean_Diff_BASS<- rep(NA, length(whichKrigingBest))
Mean_Diff_AKMCS<- rep(NA, length(whichKrigingBest))
Mean_Diff_Sobol<- rep(NA, length(whichKrigingBest))

Mean_Diff_BASS<- Mean_Time_BASS[whichKrigingBest]-Mean_Time_Kriging[whichKrigingBest]
Mean_Diff_AKMCS<- Mean_Time_AKMCS[whichKrigingBest]-Mean_Time_Kriging[whichKrigingBest]
Mean_Diff_Sobol<- Mean_Time_Sobol[whichKrigingBest]-Mean_Time_Kriging[whichKrigingBest]

Mean_Time_Kriging_Best<- Mean_Time_Kriging[whichKrigingBest]

Mean_Diff_Min<- rep(NA,length(whichKrigingBest))
min_method<- rep(NA,length(whichKrigingBest))
for(i in 1:length(whichKrigingBest)){
  Mean_Diff_Min[i]<- min(Mean_Diff_Sobol[i],Mean_Diff_BASS[i],Mean_Diff_AKMCS[i])
  if(Mean_Diff_Min[i]==Mean_Diff_BASS[i]) min_method[i]<- "BASS"
  if(Mean_Diff_Min[i]==Mean_Diff_AKMCS[i]) min_method[i]<- "AKMCS"
  if(Mean_Diff_Min[i]==Mean_Diff_Sobol[i]) min_method[i]<- "Sobol"
}


pct_diff_min<- Mean_Diff_Min/Mean_Time_Kriging_Best
pct_diff_min

Mean_Time_Kriging_Best_min<- Mean_Time_Kriging_Best/60
Mean_Time_Kriging_Best_hr<- Mean_Time_Kriging_Best/3600
Mean_Time_Kriging_Best_day<- Mean_Time_Kriging_Best_hr/24
Mean_Time_Kriging_Best_yr<- Mean_Time_Kriging_Best_day/365

Mean_Diff_Min_min<- Mean_Diff_Min/60
Mean_Diff_Min_hr<- Mean_Diff_Min/3600
Mean_Diff_Min_day<- Mean_Diff_Min_hr/24
Mean_Diff_Min_yr<- Mean_Diff_Min_day/365

Mean_Time_Kriging_Best_hr
Mean_Diff_Min_hr