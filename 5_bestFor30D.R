#get total time for each node and for each approach as a matrix

# This script makes grid plots not included in the original analysis
# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

n_nodes=4

# Total incomplete time for Kriging, BASS, and AKMCS for 30D
Time_Kriging_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_AKMCS_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_BASS_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))
Time_Sobol_30D_allseeds <- matrix(NA,nrow = n_nodes, ncol = length(tested_eval_time))

Sobol_size_30D_allseeds<- rep(NA,n_nodes)
AKMCS_size_30D_allseeds<- rep(NA,n_nodes)
BASS_size_30D_allseeds<- rep(NA,n_nodes)
Kriging_size_30D_allseeds<- rep(NA,n_nodes)


load(paste0("./Ranking_Data/Time_Sobol_node0"))

Time_Sobol_30D_allseeds[1,]<-Time_Sobol[nrow(Time_Sobol),]


  folder <- paste0("./Ranking_Data/30D")
  
  #BASS
  load(paste0(folder,"/BASS_mmESS/T_BASS"))
  load(paste0(folder,"/BASS_mmESS/T_pred_BASS"))
  load(paste0(folder,"/BASS_mmESS/T_LHS_BASS"))
  load(paste0(folder,"/BASS_mmESS/BASS_size"))
  
  #Sobol 
  load(paste0(folder,"/Sobol/S_Sobol"))
  
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
  
  AKMCS_size_30D_allseeds[1]<- AKMCS_size
  BASS_size_30D_allseeds[1]<- BASS_size
  Kriging_size_30D_allseeds[1]<- Kriging_size
  Sobol_size_30D_allseeds[1]<-S$C
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_BASS_30D_allseeds[1,j] <- sum(T_LHS_BASS) + sum(T_BASS) + sum(T_pred_BASS) + tested_eval_time[j]*BASS_size
    Time_Kriging_30D_allseeds[1,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size
    Time_AKMCS_30D_allseeds[1,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size 
  }


################################################################################
#other nodes


for(node in 1:(n_nodes-1)){
  
  # Load all related results for each test scenario
  i=length(D)
  
  print(paste0("node= ",node))
  print(paste0("k= ",i))
  
  seed<- i*node
  seed_Sobol<- i*node*10
  
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  if(node==1){
    load(paste0("./Ranking_Data/Time_Sobol_node",node))
    load(paste0("./Ranking_Data/Time_BASS_node",node))
    load(paste0("./Ranking_Data/Time_AKMCS_node",node))
    
    Time_AKMCS_30D_allseeds[node+1,]<-Time_AKMCS[nrow(Time_AKMCS),]
    Time_BASS_30D_allseeds[node+1,]<-Time_BASS[nrow(Time_BASS),]
    Time_Sobol_30D_allseeds[node+1,]<-Time_Sobol[nrow(Time_Sobol),]
    Time_Kriging_30D <- rep(NA, length(tested_eval_time))
    
    #Sobol 
    load(paste0(folder,"/Sobol/S_Sobol"))
    
    # AKMCS:
    load(paste0(folder,"/AKMCS/AKMCS_size"))
    
    #BASS
    load(paste0(folder,"/BASS_mmESS/BASS_size"))
    
    # Kriging:
    load(paste0(folder,"/Kriging/T_Kriging"))
    load(paste0(folder,"/Kriging/T_pred_Kriging"))
    load(paste0(folder,"/Kriging/T_LHS_Kriging"))
    load(paste0(folder,"/Kriging/Kriging_size"))
    
    AKMCS_size_30D_allseeds[node+1]<- AKMCS_size
    BASS_size_30D_allseeds[node+1]<- BASS_size
    Kriging_size_30D_allseeds[node+1]<- Kriging_size
    Sobol_size_30D_allseeds[node+1]<-S$C
    
    for (j in 1:length(tested_eval_time)) {
      Time_Kriging_30D_allseeds[node+1,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size
    }
    
  } else{
    load(paste0("./Ranking_Data/Time_Sobol_node",node))
    Time_Sobol_30D_allseeds[node+1,]<-Time_Sobol[nrow(Time_Sobol),]
    
    folder <- paste0("./Ranking_Data/30D")
    
    #Sobol 
    load(paste0(folder,"/Sobol/S_Sobol"))
    
    #BASS
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/T_BASS"))
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/T_pred_BASS"))
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/T_LHS_BASS"))
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/BASS_size"))
    
    # Kriging:
    load(paste0(folder,"/Kriging/seed",seed,"/T_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/T_pred_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/T_LHS_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/Kriging_size"))
    
    # AKMCS:
    load(paste0(folder,"/AKMCS/seed",seed,"/AKMCS_size"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_pred_AKMCS"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCS"))
    
    AKMCS_size_30D_allseeds[node+1]<- AKMCS_size
    BASS_size_30D_allseeds[node+1]<- BASS_size
    Kriging_size_30D_allseeds[node+1]<- Kriging_size
    Sobol_size_30D_allseeds[node+1]<-S$C
    
    # Calculation of the computational time in each scenario
    # Sensitivity analysis time + model evaluation adjusted time + emulation time
    for (j in 1:length(tested_eval_time)) {
      Time_BASS_30D_allseeds[node+1,j] <- sum(T_LHS_BASS) + sum(T_BASS) + sum(T_pred_BASS) + tested_eval_time[j]*BASS_size
      Time_Kriging_30D_allseeds[node+1,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size
      Time_AKMCS_30D_allseeds[node+1,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size 
    }
    
  }

}
  
save(Time_Sobol_30D_allseeds,file="./Ranking_Data/Time_Sobol_30D_allseeds")
save(Time_AKMCS_30D_allseeds,file="./Ranking_Data/Time_AKMCS_30D_allseeds")
save(Time_BASS_30D_allseeds,file="./Ranking_Data/Time_BASS_30D_allseeds")
save(Time_Kriging_30D_allseeds,file="./Ranking_Data/Time_Kriging_30D_allseeds")

for(j in 1:length(eval_time_lab)){
  
  print(eval_time_lab[j])
  times<- c(max(Time_Sobol_30D_allseeds[,j]),min(Time_BASS_30D_allseeds[,j]),
            min(Time_Kriging_30D_allseeds[,j]),min(Time_AKMCS_30D_allseeds[,j]))
  methods<- c("max Sobol","min BASS","min Kriging","min AKMCS")
  
  print(times[order(times)])
  print(methods[order(times)])
}

#For 1ms, 10ms, 0.1s, 1s, 10s Sobol is faster than AKMCS, BASS, Kriging for all seeds

for(j in 1:length(eval_time_lab)){
  print(eval_time_lab[j])
  
  times<- c(mean(Time_Sobol_30D_allseeds[,j]),mean(Time_BASS_30D_allseeds[,j]),
            mean(Time_Kriging_30D_allseeds[,j]),mean(Time_AKMCS_30D_allseeds[,j]))
  methods<- c("Sobol","BASS","Kriging","AKMCS")
  
  if (j<=2){
    print(paste0("In minutes"))
    print(times[order(times)]/60)
  } 
  
  if (j==3){
    print(paste0("In hours"))
    print(times[order(times)]/3600)
  } 
  if (j>3){
    print(paste0("In days"))
    print(times[order(times)]/3600/24)
  } 
  #print(times[order(times)])
  print(methods[order(times)])
}
#For 1ms, 10ms, 0.1s, 1s, 10s, Sobol fastest on average

print(Kriging_size_30D_allseeds[order(Kriging_size_30D_allseeds)])
print(BASS_size_30D_allseeds[order(BASS_size_30D_allseeds)])
print(Sobol_size_30D_allseeds[order(Sobol_size_30D_allseeds)])

bestFor30D<- c(rep("Sobol",5),rep(NA,4))
save(bestFor30D,file=paste0("./Ranking_Data/bestFor30D"))