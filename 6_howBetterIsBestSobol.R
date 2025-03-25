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

load("./Ranking_Data/textMat_maxSobol")
load("./Ranking_Data/textMat_maxBASS")
load("./Ranking_Data/textMat_maxKriging")
load("./Ranking_Data/textMat_maxAKMCS")


################################################################################
whichSobolBest<- which(textMat_maxSobol=="Sobol",arr.ind=FALSE)
whichSobolBestArr<- which(textMat_maxSobol=="Sobol",arr.ind=TRUE)

D_Sobol_Best<- tested_D[whichSobolBestArr[,1]]
time_Sobol_Best<- eval_time_lab[whichSobolBestArr[,2]]

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
#2D: not meaningful- the mean difference is less than a minute and both approaches take <1 min
#5D: not likely meaningful- difference is about 3 minutes, but Sobol only takes seconds
#10D: meaningful- difference is about half an hour, Sobol only takes seconds
#15D: very meaningful- difference is about 7.5 hours, Sobol only takes seconds
#20D: very meaningful- difference is almost 2 days, Sobol only takes seconds
#30D: add

#10ms
#2D: not meaningful- the mean difference is less than a minute and both approaches take <1 min
#5D: not likely meaningful- difference is about 3 minutes, but Sobol only takes seconds
#10D: meaningful- difference is about half an hour, Sobol only takes 1.5 min
#15D: very meaningful- difference is about 7.5 hours, Sobol only takes less than a minute
#20D: very meaningful- difference is almost 2 days (41 hours), Sobol only takes about 1.5 min
#30D: add

#.1s
#15D: very meaningful- difference is about 7.5 hours, Sobol only takes 6 min
#20D: very meaningful- difference is almost 2 days (41 hours), Sobol only takes about 11 min
#30D: add

#1s
#20: very meaningful- difference is (40 hours), Sobol takes almost 2 hours
#30D: add


for(i in 1:length(whichSobolBest)){
  print(paste0(D_Sobol_Best[i],", ",time_Sobol_Best[i]))
  print(paste0("Sobol mean: ", Mean_Time_Sobol[whichSobolBest[i]]/3600))
  print(paste0("BASS mean: ", Mean_Time_BASS[whichSobolBest[i]]/3600))
  print(paste0("Kriging mean: ", Mean_Time_Kriging[whichSobolBest[i]]/3600))
  print(paste0("AKMCS mean: ", Mean_Time_AKMCS[whichSobolBest[i]]/3600))
}

#Mean_Diff_Min_hr

#Mean_Diff_BASS_hr<- Mean_Diff_BASS/3600
#Mean_Diff_BASS_day<- Mean_Diff_BASS_hr/24
#Mean_Diff_BASS_yr<- Mean_Diff_BASS_day/365

#Mean_Diff_Kriging_hr<- Mean_Diff_Kriging/3600
#Mean_Diff_Kriging_day<- Mean_Diff_Kriging_hr/24
#Mean_Diff_Kriging_yr<- Mean_Diff_Kriging_day/365

#Mean_Diff_AKMCS_hr<- Mean_Diff_AKMCS/3600
#Mean_Diff_AKMCS_day<- Mean_Diff_AKMCS_hr/24
#Mean_Diff_AKMCS_yr<- Mean_Diff_AKMCS_day/365

#print(Mean_Time_Sobol_Best_hr)
#print(Mean_Diff_BASS_hr)
#print(Mean_Diff_Kriging_hr)
#print(Mean_Diff_AKMCS_hr)

