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

load("./Ranking_Data/textMat_maxAKMCS")

################################################################################
whichAKMCSBest<- which(textMat_maxAKMCS=="AKMCS",arr.ind=FALSE)
whichAKMCSBestArr<- which(textMat_maxAKMCS=="AKMCS",arr.ind=TRUE)

D_AKMCS_Best<- tested_D[whichAKMCSBestArr[,1]]
time_AKMCS_Best<- eval_time_lab[whichAKMCSBestArr[,2]]

save(whichAKMCSBest,whichAKMCSBestArr,D_AKMCS_Best,time_AKMCS_Best,
     file="./Ranking_Data/whichAKMCSBest")

dim_time_df<- data.frame("dim"=D_AKMCS_Best, "time"=time_AKMCS_Best)

for(i in 1:length(whichAKMCSBest)){
  print(paste0(D_AKMCS_Best[i],", ",time_AKMCS_Best[i]))
  print(paste0("AKMCS mean in minutes: ", Mean_Time_AKMCS[whichAKMCSBest[i]]/60))
  print(paste0("BASS mean in minutes: ", Mean_Time_BASS[whichAKMCSBest[i]]/60))
  print(paste0("Kriging mean in minutes: ", Mean_Time_Kriging[whichAKMCSBest[i]]/60))
  print(paste0("Sobol mean in minutes: ", Mean_Time_Sobol[whichAKMCSBest[i]]/60))
}

for(i in 1:length(whichAKMCSBest)){
  print(paste0(D_AKMCS_Best[i],", ",time_AKMCS_Best[i]))
  print(paste0("AKMCS mean in hours: ", Mean_Time_AKMCS[whichAKMCSBest[i]]/3600))
  print(paste0("BASS mean in hours: ", Mean_Time_BASS[whichAKMCSBest[i]]/3600))
  print(paste0("Kriging mean in hours: ", Mean_Time_Kriging[whichAKMCSBest[i]]/3600))
  print(paste0("Sobol mean in hours: ", Mean_Time_Sobol[whichAKMCSBest[i]]/3600))
}

for(i in 1:length(whichAKMCSBest)){
  print(paste0(D_AKMCS_Best[i],", ",time_AKMCS_Best[i]))
  print(paste0("AKMCS mean in days: ", Mean_Time_AKMCS[whichAKMCSBest[i]]/3600/24))
  print(paste0("BASS mean in days: ", Mean_Time_BASS[whichAKMCSBest[i]]/3600/24))
  print(paste0("Kriging mean in days: ", Mean_Time_Kriging[whichAKMCSBest[i]]/3600/24))
  print(paste0("Sobol mean in days: ", Mean_Time_Sobol[whichAKMCSBest[i]]/3600/24))
}

#"2D, 0.1s": everything is fast, but BASS and Kriging are slower. Still <15 min
#"2D, 1s": everything is fast (<15 min) but AKMCS is <1 min
#"2D, 10s": all but Sobol <20 min with AKMCS at 5 min, Sobol at almost 1 hr
#"2D, 1min": AKMCS and BASS both close to 30 min, Kriging and Sobol > 1 hr slower (esp Sobol)

#"5D, 10min": AKMCS saves 5-9 hours compared to Kriging and BASS. Sobol now takes days
#"5D, 1h": AKMCS saves 1- 2 days compared to Kriging and BASS. Sobol now takes over a month
#"5D, 10h": AKMCS saves at min 14 days, 310 days compared to Sobol

#"10D, 1h": AKMCS save 2 days compared to Kriging, 18 days compared to BASS, most of a year compared to Sobol
#"10D, 10h": AKMCS saves at min 20 days, 8 years compared to Sobol, ~ .5 year compared to BASS

#"15D, 10h": AKMCS saves at min 40 days, 4 years compared to Sobol, 3 years compared to BASS
#"20D, 10h": AKMCS saves at min 60 days, 7 years compared to Sobol, 6 years compared to BASS

Mean_Diff_BASS<- rep(NA, length(whichAKMCSBest))
Mean_Diff_Kriging<- rep(NA, length(whichAKMCSBest))
Mean_Diff_Sobol<- rep(NA, length(whichAKMCSBest))

Mean_Diff_BASS<- Mean_Time_BASS[whichAKMCSBest]-Mean_Time_AKMCS[whichAKMCSBest]
Mean_Diff_Kriging<- Mean_Time_Kriging[whichAKMCSBest]-Mean_Time_AKMCS[whichAKMCSBest]
Mean_Diff_Sobol<- Mean_Time_Sobol[whichAKMCSBest]-Mean_Time_AKMCS[whichAKMCSBest]

Mean_Time_AKMCS_Best<- Mean_Time_AKMCS[whichAKMCSBest]

Mean_Diff_Min<- rep(NA,length(whichAKMCSBest))
min_method<- rep(NA,length(whichAKMCSBest))
for(i in 1:length(whichAKMCSBest)){
  Mean_Diff_Min[i]<- min(Mean_Diff_Sobol[i],Mean_Diff_BASS[i],Mean_Diff_Kriging[i])
  if(Mean_Diff_Min[i]==Mean_Diff_BASS[i]) min_method[i]<- "BASS"
  if(Mean_Diff_Min[i]==Mean_Diff_Kriging[i]) min_method[i]<- "Kriging"
  if(Mean_Diff_Min[i]==Mean_Diff_Sobol[i]) min_method[i]<- "Sobol"
}

pct_diff_min<- Mean_Diff_Min/Mean_Time_AKMCS_Best
pct_diff_min

Mean_Time_AKMCS_Best_min<- Mean_Time_AKMCS_Best/60
Mean_Time_AKMCS_Best_hr<- Mean_Time_AKMCS_Best/3600
Mean_Time_AKMCS_Best_day<- Mean_Time_AKMCS_Best_hr/24
Mean_Time_AKMCS_Best_yr<- Mean_Time_AKMCS_Best_day/365

Mean_Diff_Min_min<- Mean_Diff_Min/60
Mean_Diff_Min_hr<- Mean_Diff_Min/3600
Mean_Diff_Min_day<- Mean_Diff_Min_hr/24
Mean_Diff_Min_yr<- Mean_Diff_Min_day/365

Mean_Time_AKMCS_Best_hr
Mean_Diff_Min_hr
