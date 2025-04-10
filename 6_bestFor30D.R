#get total time for each node and for each approach as a matrix

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

n_nodes=5

# Total incomplete time for Kriging and AKMCS for 30D
Time_Kriging_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_AKMCS_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_BASS_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_Sobol_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))

load(paste0("./Ranking_Data/Time_Sobol_node0"))
load(paste0("./Ranking_Data/Time_BASS_node0"))

i=1

Time_BASS_30D_allseeds[i,]<-Time_BASS[nrow(Time_BASS),]
Time_Sobol_30D_allseeds[i,]<-Time_Sobol[nrow(Time_Sobol),]


T_AKMCS_list<- list()
  folder <- paste0("./Ranking_Data/30D")
  
  # Kriging:
  load(paste0(folder,"/Kriging/T_Kriging"))
  load(paste0(folder,"/Kriging/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/T_LHS_Kriging"))
  load(paste0(folder,"/Kriging/Kriging_size"))
  #print(Kriging_size)
  
  # AKMCS:
  load(paste0(folder,"/AKMCS/AKMCS_size"))
  load(paste0(folder,"/AKMCS/T_AKMCS"))
  load(paste0(folder,"/AKMCS/T_pred_AKMCS"))
  
  #print(AKMCS_size)
  #print(length(T_AKMCS))
  T_AKMCS_list[[1]]<- T_AKMCS
  #print(max(T_AKMCS))
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Kriging_30D_allseeds[i,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size
    Time_AKMCS_30D_allseeds[i,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size 
  }


################################################################################
#other nodes


for(node in 1:(n_nodes-1)){

  load(paste0("./Ranking_Data/Time_Sobol_node",node))
  load(paste0("./Ranking_Data/Time_BASS_node",node))
  
  Time_BASS_30D_allseeds[node+1,]<-Time_BASS[nrow(Time_BASS),]
  Time_Sobol_30D_allseeds[node+1,]<-Time_Sobol[nrow(Time_Sobol),]
  
  # Total time of each method & each scenario
  Time_Kriging_30D <- rep(NA, length(tested_eval_time))
  Time_AKMCS_30D <- rep(NA, length(tested_eval_time))
  
  # Load all related results for each test scenario
  i=length(D)
  
  print(paste0("node= ",node))
  print(paste0("k= ",i))
  
  seed<- i*node
  
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Kriging:
  load(paste0(folder,"/Kriging/seed",seed,"/T_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_LHS_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/Kriging_size"))
  print(Kriging_size)
  
  if(node< (n_nodes-1)){
    # AKMCS:
    load(paste0(folder,"/AKMCS/seed",seed,"/AKMCS_size"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_pred_AKMCS"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCS"))
    
    #print(AKMCS_size)
    #print(length(T_AKMCS))
    #print(max(T_AKMCS))
    T_AKMCS_list[[node+1]]<- T_AKMCS
  }
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Kriging_30D[j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size
    if(node< (n_nodes-1)) Time_AKMCS_30D[j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size
  }
  
  Time_Kriging_30D_allseeds[node+1,]<- Time_Kriging_30D
  if(node< (n_nodes-1)) Time_AKMCS_30D_allseeds[node+1,]<- Time_AKMCS_30D
}

node=n_nodes-1
load(paste0(folder,"/AKMCS/seed",seed,"/AKMCS_size"))
load(paste0(folder,"/AKMCS/seed",seed,"/T_pred_AKMCS"))
#impute mean T_AKMCS values from other seeds with same AKMCS_size

impute_T_AKMCS<- (T_AKMCS_list[[2]]+T_AKMCS_list[[3]]+T_AKMCS_list[[4]])/3
for (j in 1:length(tested_eval_time)) {
  Time_AKMCS_30D[j] <- sum(impute_T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size
}
Time_AKMCS_30D_allseeds[node+1,]<- Time_AKMCS_30D


for(j in 1:length(eval_time_lab)){
  print(eval_time_lab[j])
  times<- c(max(Time_Sobol_30D_allseeds[,j]),max(Time_BASS_30D_allseeds[,j]),
            min(Time_Kriging_30D_allseeds[,j]),min(Time_AKMCS_30D_allseeds[,j]))
  methods<- c("max Sobol","max BASS","min Kriging","min AKMCS")
  print(times[order(times)])
  print(methods[order(times)])
}

#For 1ms, 10ms, 0.1s, 1s, Sobol is faster than AKMCS and Kriging for all seeds

for(j in 1:length(eval_time_lab)){
  print(eval_time_lab[j])
  
  times<- c(mean(Time_Sobol_30D_allseeds[,j]),mean(Time_BASS_30D_allseeds[,j]),
            mean(Time_Kriging_30D_allseeds[,j]),mean(Time_AKMCS_30D_allseeds[,j]))
  methods<- c("Sobol","BASS","Kriging","AKMCS")
  print(times[order(times)])
  print(methods[order(times)])
}
#For 1ms, 10ms, 0.1s, 1s, 10s, Sobol fastest on average

