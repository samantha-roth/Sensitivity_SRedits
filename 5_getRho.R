# Sobol's G function
# compare rankings from different approaches

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")

################################################################################
#node0

#get the rankings for standard Sobol' for each dimension
for(k in 1:(length(D)-1)){
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

all_Rho_AKMCS_node0<-rep(NA,length(D)-1)
all_Rho_BASS_node0<-rep(NA,length(D)-1)
all_Rho_Kriging_node0<-rep(NA,length(D)-1)

for(k in 1:(length(D)-1)){
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

################################################################################
#other nodes

n_nodes<- 4

for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  for(k in 1:(length(D)-1)){
    d <- D[k]
    
    print(paste0("k= ",k))
    
    seed<- k*node
    seed_Sobol<- k*node*10
    
    #Sobol
    folder <- paste0(folderpath,d,"D/Sobol/seed",seed_Sobol)
    
    load(paste0(folder,"/S_Sobol"))
    
    load(paste0(folder,"/TotSens"))
    load(paste0(folder,"/Rank"))
    
    ##############################################################################
    #AKMCS
    folder<-paste0(folderpath,d,"D/AKMCS/seed",seed)
    
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
    folder <- paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
    
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
    folder <- paste0(folderpath,d,"D/Kriging/seed",seed)
    
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
}

all_Rho_AKMCS<-matrix(NA,nrow=n_nodes,ncol=length(D)-1)
all_Rho_BASS<-matrix(NA,nrow=n_nodes,ncol=length(D)-1)
all_Rho_Kriging<-matrix(NA,nrow=n_nodes,ncol=length(D)-1)


for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  for(k in 1:(length(D)-1)){
    d <- D[k]
    
    print(paste0("k= ",k))
    
    seed<- k*node
    seed_Sobol<- k*node*10
    
    #AKMCS
    folder<-paste0(folderpath,d,"D/AKMCS/seed",seed)
    load(paste0(folder,"/Rho"))
    all_Rho_AKMCS[node+1,k]<- Rho_sum_AKMCS
    
    #BASS
    folder<-paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
    load(paste0(folder,"/Rho"))
    all_Rho_BASS[node+1,k]<- Rho_sum_BASS
    
    #Kriging
    folder<-paste0(folderpath,d,"D/Kriging/seed",seed)
    load(paste0(folder,"/Rho"))
    all_Rho_Kriging[node+1,k]<- Rho_sum_Kriging
    
  }
  
}

all_Rho_AKMCS[1,]<- all_Rho_AKMCS_node0
all_Rho_BASS[1,]<- all_Rho_BASS_node0
all_Rho_Kriging[1,]<- all_Rho_Kriging_node0

mean_Rho_AKMCS<- colMeans(all_Rho_AKMCS)
mean_Rho_BASS<- colMeans(all_Rho_BASS)
mean_Rho_Kriging<- colMeans(all_Rho_Kriging)

max_Rho_AKMCS<- apply(all_Rho_AKMCS,2,max)
max_Rho_BASS<- apply(all_Rho_BASS,2,max)
max_Rho_Kriging<- apply(all_Rho_Kriging,2,max)

min_Rho_AKMCS<- apply(all_Rho_AKMCS,2,min)
min_Rho_BASS<- apply(all_Rho_BASS,2,min)
min_Rho_Kriging<- apply(all_Rho_Kriging,2,min)

save(all_Rho_AKMCS,file=paste0(folderpath,"all_Rho_AKMCS"))
save(all_Rho_BASS,file=paste0(folderpath,"all_Rho_BASS"))
save(all_Rho_Kriging,file=paste0(folderpath,"all_Rho_Kriging"))

save(min_Rho_AKMCS,mean_Rho_AKMCS,max_Rho_AKMCS,file=paste0(folderpath,"summary_Rho_AKMCS"))
save(min_Rho_BASS,mean_Rho_BASS,max_Rho_BASS,file=paste0(folderpath,"summary_Rho_BASS"))
save(min_Rho_Kriging,mean_Rho_Kriging,max_Rho_Kriging,file=paste0(folderpath,"summary_Rho_Kriging"))

#weighted average in the difference in ranking of input parameters

