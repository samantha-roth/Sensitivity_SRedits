#get total times for different seeds

# This script makes grid plots not included in the original analysis
# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
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

n_nodes<- 5

################################################################################

#get the average times across different seeds

Time_Sobol_arr<- array(0, dim = c(length(tested_D), length(tested_eval_time), n_nodes))

load(paste0("./Ranking_Data/Time_Sobol_node0"))
Time_Sobol_arr[,,1]<- Time_Sobol

Time_BASS_arr<- array(0, dim = c(length(tested_D), length(tested_eval_time), n_nodes))

load(paste0("./Ranking_Data/Time_BASS_node0"))
Time_BASS_arr[,,1]<- Time_BASS

Time_Kriging_arr<- array(0, dim = c(length(tested_D), length(tested_eval_time), n_nodes))
load(paste0("./Ranking_Data/Time_Kriging_node0"))
Time_Kriging_arr[,,1]<- Time_Kriging

Time_AKMCS_arr<- array(0, dim = c(length(tested_D), length(tested_eval_time), n_nodes))
load(paste0("./Ranking_Data/Time_AKMCS_node0"))
Time_AKMCS_arr[,,1]<- Time_AKMCS

for(node in 2:n_nodes){
  
  load(paste0("./Ranking_Data/Time_Sobol_node",node-1))
  Time_Sobol_arr[,,node]<- Time_Sobol
  
  load(paste0("./Ranking_Data/Time_BASS_node",node-1))
  Time_BASS_arr[,,node]<- Time_BASS
  
  load(paste0("./Ranking_Data/Time_Kriging_node",node-1))
  Time_Kriging_arr[,,node]<- Time_Kriging
  
  load(paste0("./Ranking_Data/Time_AKMCS_node",node-1))
  Time_AKMCS_arr[,,node]<- Time_AKMCS
}

save(Time_Sobol_arr,file=paste0("./Ranking_Data/Time_Sobol_arr"))
save(Time_BASS_arr,file=paste0("./Ranking_Data/Time_BASS_arr"))
save(Time_Kriging_arr,file=paste0("./Ranking_Data/Time_Kriging_arr"))
save(Time_AKMCS_arr,file=paste0("./Ranking_Data/Time_AKMCS_arr"))

Mean_Time_BASS<- Time_BASS
Var_Time_BASS<- Time_BASS
Min_Time_BASS<- Time_BASS
Max_Time_BASS<- Time_BASS

Mean_Time_Sobol<- Time_Sobol
Var_Time_Sobol<- Time_Sobol
Min_Time_Sobol<- Time_Sobol
Max_Time_Sobol<- Time_Sobol

Mean_Time_Kriging<- Time_Kriging
Var_Time_Kriging<- Time_Kriging
Min_Time_Kriging<- Time_Kriging
Max_Time_Kriging<- Time_Kriging

Mean_Time_AKMCS<- Time_AKMCS
Var_Time_AKMCS<- Time_AKMCS
Min_Time_AKMCS<- Time_AKMCS
Max_Time_AKMCS<- Time_AKMCS

for(i in 1:length(tested_D)){
  for(j in 1:length(tested_eval_time)){
    
    Mean_Time_Sobol[i,j]<- mean(Time_Sobol_arr[i,j,])
    Min_Time_Sobol[i,j]<- min(Time_Sobol_arr[i,j,])
    Max_Time_Sobol[i,j]<- max(Time_Sobol_arr[i,j,])
    Var_Time_Sobol[i,j]<- var(Time_Sobol_arr[i,j,])
    
    Mean_Time_BASS[i,j]<- mean(Time_BASS_arr[i,j,])
    Min_Time_BASS[i,j]<- min(Time_BASS_arr[i,j,])
    Max_Time_BASS[i,j]<- max(Time_BASS_arr[i,j,])
    Var_Time_BASS[i,j]<- var(Time_BASS_arr[i,j,])
    
    Mean_Time_Kriging[i,j]<- mean(Time_Kriging_arr[i,j,])
    Min_Time_Kriging[i,j]<- min(Time_Kriging_arr[i,j,])
    Max_Time_Kriging[i,j]<- max(Time_Kriging_arr[i,j,])
    Var_Time_Kriging[i,j]<- var(Time_Kriging_arr[i,j,])
    
    Mean_Time_AKMCS[i,j]<- mean(Time_AKMCS_arr[i,j,])
    Min_Time_AKMCS[i,j]<- min(Time_AKMCS_arr[i,j,])
    Max_Time_AKMCS[i,j]<- max(Time_AKMCS_arr[i,j,])
    Var_Time_AKMCS[i,j]<- var(Time_AKMCS_arr[i,j,])
  }
}

save(Mean_Time_Sobol,Min_Time_Sobol,Max_Time_Sobol,Var_Time_Sobol,
     file=paste0("./Ranking_Data/Summary_Time_Sobol"))

save(Mean_Time_BASS,Min_Time_BASS,Max_Time_BASS,Var_Time_BASS,
     file=paste0("./Ranking_Data/Summary_Time_BASS"))

save(Mean_Time_Kriging,Min_Time_Kriging,Max_Time_Kriging,Var_Time_Kriging,
     file=paste0("./Ranking_Data/Summary_Time_Kriging"))

save(Mean_Time_AKMCS,Min_Time_AKMCS,Max_Time_AKMCS,Var_Time_AKMCS,
     file=paste0("./Ranking_Data/Summary_Time_AKMCS"))

