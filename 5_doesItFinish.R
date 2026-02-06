#which methods never finish for 30D?

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

n_nodes<- 5

Finished_Sobol <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)
Finished_BASS <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)
Finished_Kriging <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)
Finished_AKMCS <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)

#did the process finish for node 0?
for (i in 1:(length(D))) {
  print(tested_D[i])
  
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Sobol:
  print(paste0("Sobol: ",file.exists(paste0(folder,"/Sobol/avg_eval_time"))))
  Finished_Sobol[i,1]<- file.exists(paste0(folder,"/Sobol/avg_eval_time"))
  
  # BASS:
  print(paste0("BASS: ",file.exists(paste0(folder,"/BASS_mmESS/S_BASS_list"))))
  Finished_BASS[i,1]<- file.exists(paste0(folder,"/BASS_mmESS/S_BASS_list"))
  
  # Kriging:
  print(paste0("Kriging: ",file.exists(paste0(folder,"/Kriging/Sobol_Kriging_convergesize"))))
  Finished_Kriging[i,1]<- file.exists(paste0(folder,"/Kriging/Sobol_Kriging_convergesize"))
  
  # AKMCS:
  print(paste0("AKMCS: ",file.exists(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))))
  Finished_AKMCS[i,1]<- file.exists(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))
  
}

#nothing but Sobol' finished at 30D


#did the process finish for other nodes?

for(node in 1:(n_nodes-1)){
  print(paste0("node= ",node))

  for (i in 1:(length(D))) {
    print(tested_D[i])
    
    seed<- i*node
    seed_Sobol<- i*node*10
    
    folder <- paste0("./Ranking_Data/",tested_D[i])
    
    # Sobol:
    print(paste0("Sobol: ",file.exists(paste0(folder,"/Sobol/seed",seed_Sobol,"/avg_eval_time"))))
    Finished_Sobol[i,node+1]<- file.exists(paste0(folder,"/Sobol/seed",seed_Sobol,"/avg_eval_time"))
    
    # BASS:
    print(paste0("BASS: ",file.exists(paste0(folder,"/BASS_mmESS/seed",seed,"/S_BASS_list"))))
    Finished_BASS[i,node+1]<- file.exists(paste0(folder,"/BASS_mmESS/seed",seed,"/S_BASS_list"))
      
    # Kriging:
    print(paste0("Kriging: ",file.exists(paste0(folder,"/Kriging/seed",seed,"/Sobol_Kriging_convergesize"))))
    Finished_Kriging[i,node+1]<- file.exists(paste0(folder,"/Kriging/seed",seed,"/Sobol_Kriging_convergesize"))
      
    # AKMCS:
    print(paste0("AKMCS: ",file.exists(paste0(folder,"/AKMCS/seed",seed,"/Sobol_AKMCS_convergesize"))))
    Finished_AKMCS[i,node+1]<- file.exists(paste0(folder,"/AKMCS/seed",seed,"/Sobol_AKMCS_convergesize"))
      
  }
  
}