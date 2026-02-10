# Polynomial function
# compare results from AKMCS, BASS, and Kriging to standard Sobol

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

# setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

source("0_libraryPoly.R")

#node0
#get the rankings for standard Sobol' for each dimension
for(k in 1:3){
  d <- D[k]
  
  #Sobol
  folder <- paste0(folderpath,d,"D/Sobol")
  
  load(paste0(folder,"/S_Sobol"))
  
  TotSens <- S$boot$t0[c((1+d):(2*d))]
  Rank <- rank(-TotSens,ties.method="average")
  save(TotSens,file=paste0(folder,"/TotSens"))
  save(Rank,file=paste0(folder,"/Rank"))
  
  #AKMCS
  folder<-paste0(folderpath,d,"D/AKMCS")
  
  load(paste0(folder,"/S_AKMCS"))
  
  TotSens_AKMCS <- S_AKMCS$boot$t0[c((1+d):(2*d))]
  Rank_AKMCS <- rank(-TotSens_AKMCS,ties.method="average")
  save(TotSens_AKMCS,file=paste0(folder,"/TotSens"))
  save(Rank_AKMCS,file=paste0(folder,"/Rank"))
  
  #BASS
  folder <- paste0(folderpath,d,"D/BASS_mmESS")
  
  load(paste0(folder,"/S_BASS_list"))
  
  if(length(S_BASS_list)==1){
    S_BASS<- S_BASS_list[[1]]
    S_BASS_T<- S_BASS$T
    TotSens_BASS<- colMeans(S_BASS_T)
    Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
    save(TotSens_BASS,file=paste0(folder,"/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/Rank"))
  } else{
    L<- length(S_BASS_list)
    bigT<- rep(NA, d)
    for(l in 1:L){
      littleT<- S_BASS_list[[l]]$T
      bigT<- rbind(bigT,littleT)
    }
    bigT<- bigT[-1,]
    TotSens_BASS<- colMeans(bigT)
    Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
    save(TotSens_BASS,file=paste0(folder,"/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/Rank"))
  }
  
  #Kriging
  folder <- paste0(folderpath,d,"D/Kriging")
  
  load(paste0(folder,"/S_Kriging"))
  
  TotSens_Kriging <- S_Kriging$boot$t0[c((1+d):(2*d))]
  Rank_Kriging <- rank(-TotSens_Kriging,ties.method="average")
  save(TotSens_Kriging,file=paste0(folder,"/TotSens"))
  save(Rank_Kriging,file=paste0(folder,"/Rank"))
}

#compute rho values
for(k in 1:3){
  d <- D[k]
  
  #Sobol
  folder <- paste0(folderpath,d,"D/Sobol")
  
  load(paste0(folder,"/S_Sobol"))
  
  load(paste0(folder,"/TotSens"))
  load(paste0(folder,"/Rank"))
  
  ##############################################################################
  #AKMCS
  folder<-paste0(folderpath,d,"D/AKMCS")
  
  load(paste0(folder,"/S_AKMCS"))
  
  load(paste0(folder,"/TotSens"))
  load(paste0(folder,"/Rank"))
  
  Rho_AKMCS <- rep(NA,d)
  Weights_AKMCS <- rep(NA,d)
  for (para_ind in 1:d){
    Weights_AKMCS[para_ind] <- (max(TotSens[para_ind],TotSens_AKMCS[para_ind]))^2
  }
  Weights_sum_AKMCS <- sum(Weights_AKMCS)
  for (para_ind in 1:d){
    Rho_AKMCS[para_ind] <- abs(Rank[para_ind]-Rank_AKMCS[para_ind])*
      Weights_AKMCS[para_ind]/Weights_sum_AKMCS
  }
  Rho_sum_AKMCS<- sum(Rho_AKMCS)
  save(Rho_sum_AKMCS,Rho_AKMCS,file=paste0(folder,"/Rho"))
  save(Weights_AKMCS,Weights_sum_AKMCS,file=paste0(folder,"/Weights"))
  
  ##############################################################################
  #BASS
  folder <- paste0(folderpath,d,"D/BASS_mmESS")
  
  load(paste0(folder,"/S_BASS_list"))
  
  load(paste0(folder,"/TotSens"))
  load(paste0(folder,"/Rank"))
  
  Rho_BASS <- rep(NA,d)
  Weights_BASS <- rep(NA,d)
  for (para_ind in 1:d){
    Weights_BASS[para_ind] <- (max(TotSens[para_ind],TotSens_BASS[para_ind]))^2
  }
  Weights_sum_BASS <- sum(Weights_BASS)
  for (para_ind in 1:d){
    Rho_BASS[para_ind] <- abs(Rank[para_ind]-Rank_BASS[para_ind])*
      Weights_BASS[para_ind]/Weights_sum_BASS
  }
  Rho_sum_BASS<- sum(Rho_BASS)
  save(Rho_sum_BASS,Rho_BASS,file=paste0(folder,"/Rho"))
  save(Weights_BASS,Weights_sum_BASS,file=paste0(folder,"/Weights"))
  
  ##############################################################################
  #Kriging
  folder <- paste0(folderpath,d,"D/Kriging")
  
  load(paste0(folder,"/S_Kriging"))
  
  load(paste0(folder,"/TotSens"))
  load(paste0(folder,"/Rank"))
  
  Rho_Kriging <- rep(NA,d)
  Weights_Kriging <- rep(NA,d)
  for (para_ind in 1:d){
    Weights_Kriging[para_ind] <- (max(TotSens[para_ind],TotSens_Kriging[para_ind]))^2
  }
  Weights_sum_Kriging <- sum(Weights_Kriging)
  for (para_ind in 1:d){
    Rho_Kriging[para_ind] <- abs(Rank[para_ind]-Rank_Kriging[para_ind])*
      Weights_Kriging[para_ind]/Weights_sum_Kriging
  }
  Rho_sum_Kriging<- sum(Rho_Kriging)
  save(Rho_sum_Kriging,Rho_Kriging,file=paste0(folder,"/Rho"))
  save(Weights_Kriging,Weights_sum_Kriging,file=paste0(folder,"/Weights"))
  
}

all_Rho_AKMCS_node0<-rep(NA,3)
all_Rho_BASS_node0<-rep(NA,3)
all_Rho_Kriging_node0<-rep(NA,3)

for(k in 1:3){
  d <- D[k]
  
  #AKMCS
  folder<-paste0(folderpath,d,"D/AKMCS")
  load(paste0(folder,"/Rho"))
  all_Rho_AKMCS_node0[k]<- Rho_sum_AKMCS
  
  #BASS
  folder<-paste0(folderpath,d,"D/BASS_mmESS")
  load(paste0(folder,"/Rho"))
  all_Rho_BASS_node0[k]<- Rho_sum_BASS
  
  #Kriging
  folder<-paste0(folderpath,d,"D/Kriging")
  load(paste0(folder,"/Rho"))
  all_Rho_Kriging_node0[k]<- Rho_sum_Kriging
}

for(k in 1:3){
  print(paste0(D[k],"D"))
  print(paste0("AKMCS: your rho=", all_Rho_AKMCS_node0[k]))
  print(paste0("BASS: your rho=", all_Rho_BASS_node0[k]))
  print(paste0("Kriging: your rho=", all_Rho_Kriging_node0[k]))
  if(k==1){
    print(paste0("AKMCS: my rho=", 0))
    print(paste0("BASS: my rho=", 0))
    print(paste0("Kriging: my rho=", 0))
  }
  if(k==2){
    print(paste0("AKMCS: my rho=", 0.0134416481174996))
    print(paste0("BASS: my rho=", 0.0771794295819732))
    print(paste0("Kriging: my rho=", 0.00761025504752504))
  }
  if(k==3){
    print(paste0("AKMCS: my rho=", 0.204985665348551))
    print(paste0("BASS: my rho=", 0.0963638861666487))
    print(paste0("Kriging: my rho=", 0.558069028141977))
  }
}

