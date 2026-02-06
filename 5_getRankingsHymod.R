# Hymod
# compare results from AKMCS, BASS, and Kriging to standard Sobol

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_libraryHymod.R")

folder <- paste0("./Ranking_Data/Hymod")

#node0
#get the rankings for standard Sobol' for each dimension
k=1
  d <- D[k]
  
  #Sobol
  
  load(paste0(folder,"/Sobol/S_Sobol"))
  
  TotSens <- S$boot$t0[c((1+d):(2*d))]
  Rank <- rank(-TotSens,ties.method="average")
  save(TotSens,file=paste0(folder,"/Sobol/TotSens"))
  save(Rank,file=paste0(folder,"/Sobol/Rank"))
  
  #AKMCS
  
  load(paste0(folder,"/AKMCS/S_AKMCS"))
  
  TotSens_AKMCS <- S_AKMCS$boot$t0[c((1+d):(2*d))]
  Rank_AKMCS <- rank(-TotSens_AKMCS,ties.method="average")
  save(TotSens_AKMCS,file=paste0(folder,"/AKMCS/TotSens"))
  save(Rank_AKMCS,file=paste0(folder,"/AKMCS/Rank"))
  
  #BASS

  load(paste0(folder,"/BASS_mmESS/S_BASS_list"))
  
  if(length(S_BASS_list)==1){
    S_BASS<- S_BASS_list[[1]]
    S_BASS_T<- S_BASS$T
    TotSens_BASS<- colMeans(S_BASS_T)
    Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
    save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/Rank"))
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
    save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/Rank"))
  }
  
  #Kriging

  load(paste0(folder,"/Kriging/S_Kriging"))
  
  TotSens_Kriging <- S_Kriging$boot$t0[c((1+d):(2*d))]
  Rank_Kriging <- rank(-TotSens_Kriging,ties.method="average")
  save(TotSens_Kriging,file=paste0(folder,"/Kriging/TotSens"))
  save(Rank_Kriging,file=paste0(folder,"/Kriging/Rank"))


################################################################################
#other nodes

n_nodes<- 4

for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  k=1
    d <- D[k]
    
    print(paste0("k= ",k))
    
    seed<- node*10
    seed_Sobol<- node*3
    seed_BASS<- node*2
    
    #Sobol
    
    load(paste0(folder,"/Sobol/seed",seed_Sobol,"/S_Sobol"))
    
    TotSens <- S$boot$t0[c((1+d):(2*d))]
    Rank <- rank(-TotSens,ties.method="average")
    save(TotSens,file=paste0(folder,"/Sobol/seed",seed_Sobol,"/TotSens"))
    save(Rank,file=paste0(folder,"/Sobol/seed",seed_Sobol,"/Rank"))
    
    #AKMCS

    load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
    
    TotSens_AKMCS <- S_AKMCS$boot$t0[c((1+d):(2*d))]
    Rank_AKMCS <- rank(-TotSens_AKMCS,ties.method="average")
    save(TotSens_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/TotSens"))
    save(Rank_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/Rank"))
    
    #BASS

    load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/S_BASS_list"))
    
    if(length(S_BASS_list)==1){
      S_BASS<- S_BASS_list[[1]]
      S_BASS_T<- S_BASS$T
      TotSens_BASS<- colMeans(S_BASS_T)
      Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
      save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/TotSens"))
      save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rank"))
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
      save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/TotSens"))
      save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rank"))
    }
    
    #Kriging

    load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
    
    TotSens_Kriging <- S_Kriging$boot$t0[c((1+d):(2*d))]
    Rank_Kriging <- rank(-TotSens_Kriging,ties.method="average")
    save(TotSens_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/TotSens"))
    save(Rank_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/Rank"))
  
  
}

