# SacSma10
# compare results from AKMCS, BASS, and Kriging to standard Sobol

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_librarySACSMA10par.R")

folder <- paste0("./Ranking_Data/SacSma10")

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
  cnlt<- as.numeric(colnames(S_BASS_T))
  TotSens_BASS1<- colMeans(S_BASS_T)
  TotSens_BASS<- rep(0,d)
  TotSens_BASS[cnlt]<- TotSens_BASS1
  Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
  save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/TotSens"))
  save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/Rank"))
} else{
  L<- length(S_BASS_list)
  bigT<- rep(NA, d)
  tot_rows<- 0
  for(l in 1:L){
    littleT<- S_BASS_list[[l]]$T
    tot_rows<- tot_rows+nrow(littleT)
    cnlt<- as.numeric(colnames(littleT))
    littleT_filled<- matrix(0,nrow=nrow(littleT),ncol=d)
    for(col in 1:d){
      cn<- as.character(col)
      if(col%in%cnlt) littleT_filled[,col]<- littleT[,cn]
    }
    bigT<- rbind(bigT,littleT_filled)
  }
  bigT<- bigT[-1,]
  TotSens_BASS<- colMeans(bigT)
  Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
  save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/TotSens"))
  save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/Rank"))
}
#missing: 5,7,8

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
  seed_Sobol<- seed_BASS<- node*3
  
  #Sobol
  
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/S_Sobol"))
  
  TotSens <- S$boot$t0[c((1+d):(2*d))]
  Rank <- rank(-TotSens,ties.method="average")
  save(TotSens,file=paste0(folder,"/Sobol/seed",seed_Sobol,"/TotSens"))
  save(Rank,file=paste0(folder,"/Sobol/seed",seed_Sobol,"/Rank"))
  
  print("Sobol done")
  
  #AKMCS
  
  load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
  
  TotSens_AKMCS <- S_AKMCS$boot$t0[c((1+d):(2*d))]
  Rank_AKMCS <- rank(-TotSens_AKMCS,ties.method="average")
  save(TotSens_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/TotSens"))
  save(Rank_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/Rank"))
  
  print("AKMCS done")
  
  #BASS
  
  load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/S_BASS_list"))
  
  if(length(S_BASS_list)==1){
    S_BASS<- S_BASS_list[[1]]
    S_BASS_T<- S_BASS$T
    cnlt<- as.numeric(colnames(S_BASS_T))
    TotSens_BASS1<- colMeans(S_BASS_T)
    TotSens_BASS<- rep(0,d)
    TotSens_BASS[cnlt]<- TotSens_BASS1
    Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
    save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rank"))
  } else{
    L<- length(S_BASS_list)
    bigT<- rep(NA, d)
    tot_rows<- 0
    for(l in 1:L){
      littleT<- S_BASS_list[[l]]$T
      tot_rows<- tot_rows+nrow(littleT)
      cnlt<- as.numeric(colnames(littleT))
      littleT_filled<- matrix(0,nrow=nrow(littleT),ncol=d)
      for(col in 1:d){
        cn<- as.character(col)
        if(col%in%cnlt) littleT_filled[,col]<- littleT[,cn]
      }
      bigT<- rbind(bigT,littleT_filled)
    }
    bigT<- bigT[-1,]
    TotSens_BASS<- colMeans(bigT)
    Rank_BASS <- rank(-TotSens_BASS,ties.method="average")
    save(TotSens_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/TotSens"))
    save(Rank_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rank"))
  }
  
  print("BASS done")
  
  #Kriging
  
  load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
  
  TotSens_Kriging <- S_Kriging$boot$t0[c((1+d):(2*d))]
  Rank_Kriging <- rank(-TotSens_Kriging,ties.method="average")
  save(TotSens_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/TotSens"))
  save(Rank_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/Rank"))
  
  print("Kriging done")
}
#node 1- only 3 got skipped
#node 2- none skipped
#node 3- first entry: 3 got skipped, second entry: 2 got skipped
