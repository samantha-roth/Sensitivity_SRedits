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

load("./Ranking_Data/whichSobolBest")
load("./Ranking_Data/whichKrigingBest")
load("./Ranking_Data/whichAKMCSBest")

################################################################################

all_mat_inds<- 1:(length(eval_time_lab)*length(tested_D))
whichNoBest<- all_mat_inds[-c(whichAKMCSBest,whichSobolBest,whichKrigingBest)]

all_rows<- rep(1:length(tested_D),length(eval_time_lab))
all_cols<- rep(1:length(eval_time_lab),each=length(tested_D))
all_arr_inds<- cbind(all_rows,all_cols)

all_dims<- rep(tested_D,length(eval_time_lab))
all_times<- rep(eval_time_lab,each=length(tested_D))


for(i in 1:length(whichNoBest)){
  if(all_dims[whichNoBest[i]]=="5D"){
  #if(all_dims[whichNoBest[i]]!="30D"){
    print(paste0(all_times[whichNoBest[i]],", ",all_dims[whichNoBest[i]]))
    print(paste0("Kriging in minutes: ",Min_Time_Kriging[whichNoBest[i]]/60,", ",
                 Mean_Time_Kriging[whichNoBest[i]]/60,", ",
                 Max_Time_Kriging[whichNoBest[i]]/60))
    print(paste0("BASS in minutes: ",Min_Time_BASS[whichNoBest[i]]/60,", ",
                 Mean_Time_BASS[whichNoBest[i]]/60,", ",
                 Max_Time_BASS[whichNoBest[i]]/60))
    print(paste0("AKMCS in minutes: ",Min_Time_AKMCS[whichNoBest[i]]/60,", ",
                 Mean_Time_AKMCS[whichNoBest[i]]/60,", ",
                 Max_Time_AKMCS[whichNoBest[i]]/60))
    print(paste0("Sobol in minutes: ",Min_Time_Sobol[whichNoBest[i]]/60,", ",
                 Mean_Time_Sobol[whichNoBest[i]]/60,", ",
                 Max_Time_Sobol[whichNoBest[i]]/60))
  }
}

for(i in 1:length(whichNoBest)){
  if(all_dims[whichNoBest[i]]!="30D"){
    print(paste0(all_times[whichNoBest[i]],", ",all_dims[whichNoBest[i]]))
    print(paste0("Kriging in hours: ",Min_Time_Kriging[whichNoBest[i]]/3600,", ",
                 Mean_Time_Kriging[whichNoBest[i]]/3600,", ",
                 Max_Time_Kriging[whichNoBest[i]]/3600))
    print(paste0("BASS in hours: ",Min_Time_BASS[whichNoBest[i]]/3600,", ",
                 Mean_Time_BASS[whichNoBest[i]]/3600,", ",
                 Max_Time_BASS[whichNoBest[i]]/3600))
    print(paste0("AKMCS in hours: ",Min_Time_AKMCS[whichNoBest[i]]/3600,", ",
                 Mean_Time_AKMCS[whichNoBest[i]]/3600,", ",
                 Max_Time_AKMCS[whichNoBest[i]]/3600))
    print(paste0("Sobol in hours: ",Min_Time_Sobol[whichNoBest[i]]/3600,", ",
                 Mean_Time_Sobol[whichNoBest[i]]/3600,", ",
                 Max_Time_Sobol[whichNoBest[i]]/3600))
  }
}

for(i in 1:length(whichNoBest)){
  if(all_dims[whichNoBest[i]]!="30D"){
    print(paste0(all_times[whichNoBest[i]],", ",all_dims[whichNoBest[i]]))
    print(paste0("Kriging in days: ",Min_Time_Kriging[whichNoBest[i]]/3600/24,", ",
                 Mean_Time_Kriging[whichNoBest[i]]/3600/24,", ",
                 Max_Time_Kriging[whichNoBest[i]]/3600/24))
    print(paste0("BASS in days: ",Min_Time_BASS[whichNoBest[i]]/3600/24,", ",
                 Mean_Time_BASS[whichNoBest[i]]/3600/24,", ",
                 Max_Time_BASS[whichNoBest[i]]/3600/24))
    print(paste0("AKMCS in days: ",Min_Time_AKMCS[whichNoBest[i]]/3600/24,", ",
                 Mean_Time_AKMCS[whichNoBest[i]]/3600/24,", ",
                 Max_Time_AKMCS[whichNoBest[i]]/3600/24))
    print(paste0("Sobol in days: ",Min_Time_Sobol[whichNoBest[i]]/3600/24,", ",
                 Mean_Time_Sobol[whichNoBest[i]]/3600/24,", ",
                 Max_Time_Sobol[whichNoBest[i]]/3600/24))
  }
}


#"0.1s, 5D": should really choose Sobol (<2min), but Kriging and Sobol are both <15min
#"0.1s, 10D": should really choose Sobol (<17min), second best Kriging has wide range up to 1 hr

#"1s, 5D": Kriging fastest (5min), but AKMCS and Sobol also always <16min
#"1s, 10D": Kriging fastest (37min), all others have too high of means and/or maxes
#"1s, 15D": Sobol fastest (1hr), all others have too wide of ranges

#"10s, 5D": AKMCS fastest (15min), Kriging close in 2nd, others slower
#"10s, 10D": Kriging fastest (1 hr), others have too high of means
#"10s, 15D": Kriging fastest (8 hr), but can be slightly slower than Sobol (close 2nd). others too slow
#"10s, 20D": Sobol fastest (18 hr), all others too slow/variable

#"1min, 5D": AKMCS fastest (1 hr), others at least half an hour slower, Sobol BAD
#"1min, 15D": Kriging fastest (10 hrs), others too slow/variable
#"1min, 20D": Kriging fastest (46 hrs), others too slow/variable

#"10min, 2D": AKMCS fastest (4 hrs), BASS about the same, others slower
#"10min, 10D": AKMCS fastest (18 hrs), Kriging close second, others way slower
#"10min, 15D": AKMCS fastest (38 hrs), Kriging about the same, others way slwoer
#"10min, 20D": Kriging fastest (3.8 days), AKMCS second, others way slower

#"1h, 2D": AKMCS fastest (1 days), BASS about the same, others slower especially Sobol
#"1h, 15D": AKMCS fastest (5 days), Kriging second, others much slower
#"1h, 20D": AKMCS fastest (9 days), Kriging second, others much slower

#"10h, 2D": AKMCS fastest (10 days), BASS about the same, others much slower
