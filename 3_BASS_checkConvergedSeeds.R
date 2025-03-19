#check which of the seeds have not converged

#check 1: do T_check_BASS, T_BASSSobol, and S_BASS exist?
rm(list = ls())
graphics.off()

source("0_library.R")

for(k in 1:6){
  for(node in 1:4){
    print(paste0("k= ",k))
    seed<- node*k
    print(paste0("seed= ",seed))
    d=D[k]
    
    folder<-paste0(folderpath,d,"D/BASS/seed",seed)
    
    try(load(paste0(folder, "/T_check_BASS")))
    try(load(paste0(folder,"/T_BASSSobol")))
    try(load(paste0(folder,"/S_BASS")))
  }
}
#now we know seeds 24 and 12 need to be continued for k=6
#everything else has converged

################################################################################
#check seed 6

node=1
  k=6
  seed<- node*k
  print(paste0("seed= ",seed))
  d=D[k]
  
  folder<-paste0(folderpath,d,"D/BASS/seed",seed)
  
  load(paste0(folder,"/S_BASS"))
  
  Important_indices <- as.numeric(names(S_BASS$T[1, ]))
  
  S_total <- rep(NA,d)
  for (j in 1:length(Important_indices)){
    S_total[Important_indices[j]] <- quantile(S_BASS$T[ ,j],probs = 0.975) - quantile(S_BASS$T[ ,j],probs = 0.025)
  }

  Sens <- S_BASS$T[seq(4,400,by=4),c(1:length(Important_indices))]
  Rank <- t(apply(Sens, 1, rank))
  for (boot_ind1 in 1:99){
    T <- boot_ind1
    for (boot_ind2 in (T+1):100){
      Rho <- rep(NA,length(Important_indices))
      Weights <- rep(NA,length(Important_indices))
      for (para_ind in 1:length(Important_indices)){
        Weights[para_ind] <- (max(Sens[boot_ind1,para_ind],max(Sens[boot_ind2,para_ind])))^2
      }
      Weights_sum <- sum(Weights)
      for (para_ind in 1:length(Important_indices)){
        Rho[para_ind] <- abs(Rank[boot_ind1,para_ind]-Rank[boot_ind2,para_ind])*
          Weights[para_ind]/Weights_sum
      }
      if (boot_ind2 == 2){
        Rho_all <- Rho
      } else{
        Rho_all <- append(Rho_all,Rho)
      }
    }
  }
  Rho_all <- matrix(Rho_all, nrow = d)
  Rho_all <- apply(Rho_all, 2, sum)
  
  print(paste0("Less than 1: ", quantile(Rho_all,probs = 0.95, na.rm = TRUE)< 1))
  #for seed 6 we have convergence
  
################################################################################
#check seed 18

node=3
  k=6
  seed<- node*k
  print(paste0("seed= ",seed))
  d=D[k]
  
  folder<-paste0(folderpath,d,"D/BASS/seed",seed)
  
  load(paste0(folder,"/S_BASS"))
  
  Important_indices <- as.numeric(names(S_BASS$T[1, ]))
  
  S_total <- rep(NA,d)
  for (j in 1:length(Important_indices)){
    S_total[Important_indices[j]] <- quantile(S_BASS$T[ ,j],probs = 0.975) - quantile(S_BASS$T[ ,j],probs = 0.025)
  }

  Sens <- S_BASS$T[seq(4,400,by=4),c(1:length(Important_indices))]
  Rank <- t(apply(Sens, 1, rank))
  for (boot_ind1 in 1:99){
    T <- boot_ind1
    for (boot_ind2 in (T+1):100){
      Rho <- rep(NA,length(Important_indices))
      Weights <- rep(NA,length(Important_indices))
      for (para_ind in 1:length(Important_indices)){
        Weights[para_ind] <- (max(Sens[boot_ind1,para_ind],max(Sens[boot_ind2,para_ind])))^2
      }
      Weights_sum <- sum(Weights)
      for (para_ind in 1:length(Important_indices)){
        Rho[para_ind] <- abs(Rank[boot_ind1,para_ind]-Rank[boot_ind2,para_ind])*
          Weights[para_ind]/Weights_sum
      }
      if (boot_ind2 == 2){
        Rho_all <- Rho
      } else{
        Rho_all <- append(Rho_all,Rho)
      }
    }
  }
  Rho_all <- matrix(Rho_all, nrow = d)
  Rho_all <- apply(Rho_all, 2, sum)
  
  print(paste0("Less than 1: ", quantile(Rho_all,probs = 0.95, na.rm = TRUE)< 1))
  #for seed 18 we have convergence
  
  
  
  
  