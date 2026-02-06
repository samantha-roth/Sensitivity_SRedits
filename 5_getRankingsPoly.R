# Polynomial function
# compare results from AKMCS, BASS, and Kriging to standard Sobol

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

source("0_libraryPoly.R")

#node0
#get the rankings for standard Sobol' for each dimension
for(k in 1:(length(D))){
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

################################################################################
#other nodes

n_nodes<- 4

for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  for(k in 1:(length(D))){
    d <- D[k]
    
    print(paste0("k= ",k))
    
    seed<- k*node
    seed_Sobol<- k*node*10
    
    #Sobol
    folder <- paste0(folderpath,d,"D/Sobol/seed",seed_Sobol)
    
    load(paste0(folder,"/S_Sobol"))
    
    TotSens <- S$boot$t0[c((1+d):(2*d))]
    Rank <- rank(-TotSens,ties.method="average")
    save(TotSens,file=paste0(folder,"/TotSens"))
    save(Rank,file=paste0(folder,"/Rank"))
    
    #AKMCS
    folder<-paste0(folderpath,d,"D/AKMCS/seed",seed)
    
    load(paste0(folder,"/S_AKMCS"))
    
    TotSens_AKMCS <- S_AKMCS$boot$t0[c((1+d):(2*d))]
    Rank_AKMCS <- rank(-TotSens_AKMCS,ties.method="average")
    save(TotSens_AKMCS,file=paste0(folder,"/TotSens"))
    save(Rank_AKMCS,file=paste0(folder,"/Rank"))
    
    #BASS
    folder <- paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
    
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
    folder <- paste0(folderpath,d,"D/Kriging/seed",seed)
    
    load(paste0(folder,"/S_Kriging"))
    
    TotSens_Kriging <- S_Kriging$boot$t0[c((1+d):(2*d))]
    Rank_Kriging <- rank(-TotSens_Kriging,ties.method="average")
    save(TotSens_Kriging,file=paste0(folder,"/TotSens"))
    save(Rank_Kriging,file=paste0(folder,"/Rank"))
  }
  
}

################################################################################
#check what's going on with BASS

for(k in 1:(length(D))){
  d <- D[k]
  print(paste0("d=",d))
  
  folder <- paste0(folderpath,d,"D/BASS_mmESS")
  
  load(paste0(folder,"/S_BASS_list"))
  
  # print(length(S_BASS_list)==1)
  
  S_BASS<- S_BASS_list[[1]]
  S_BASS_T<- S_BASS$T
  
  print(paste0("ncol(S_BASS_T)=",ncol(S_BASS_T)))
  
}

n_nodes<- 4

for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  for(k in 1:(length(D))){
    d <- D[k]
    
    print(paste0("k= ",k))
    
    seed<- k*node
    seed_Sobol<- k*node*10
    
    folder <- paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
    
    load(paste0(folder,"/S_BASS_list"))
    
    S_BASS<- S_BASS_list[[1]]
    S_BASS_T<- S_BASS$T
    
    print(paste0("ncol(S_BASS_T)=",ncol(S_BASS_T)))
  }
}
