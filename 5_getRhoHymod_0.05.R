# Hymod
# compare rankings from different approaches
# where variables that are barely sensitive are ignored

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_libraryHymod.R")

folder <- paste0("./Ranking_Data/Hymod")

################################################################################
#node0

#get the rankings for standard Sobol' for each dimension
k=1
d <- D[k]

#Sobol

load(paste0(folder,"/Sobol/S_Sobol"))

load(paste0(folder,"/Sobol/TotSens"))
load(paste0(folder,"/Sobol/Rank"))

##############################################################################
#AKMCS

load(paste0(folder,"/AKMCS/S_AKMCS"))

load(paste0(folder,"/AKMCS/TotSens"))
load(paste0(folder,"/AKMCS/Rank"))

importantPars<- which(TotSens>0.05)
if(length(importantPars)>=1){
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
save(Rho_sum_AKMCS,Rho_AKMCS,file=paste0(folder,"/AKMCS/Rho_0.05"))
save(Weights_AKMCS,Weights_sum_AKMCS,file=paste0(folder,"/AKMCS/Weights_0.05"))
} else print("no important pars")

##############################################################################
#BASS

load(paste0(folder,"/BASS_mmESS/S_BASS_list"))

load(paste0(folder,"/BASS_mmESS/TotSens"))
load(paste0(folder,"/BASS_mmESS/Rank"))

importantPars<- which(TotSens>0.05)
if(length(importantPars)>=1){
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
save(Rho_sum_BASS,Rho_BASS,file=paste0(folder,"/BASS_mmESS/Rho_0.05"))
save(Weights_BASS,Weights_sum_BASS,file=paste0(folder,"/BASS_mmESS/Weights_0.05"))
}else print("no important pars")

##############################################################################
#Kriging

load(paste0(folder,"/Kriging/S_Kriging"))

load(paste0(folder,"/Kriging/TotSens"))
load(paste0(folder,"/Kriging/Rank"))

importantPars<- which(TotSens>0.05)
if(length(importantPars)>=1){
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
save(Rho_sum_Kriging,Rho_Kriging,file=paste0(folder,"/Kriging/Rho_0.05"))
save(Weights_Kriging,Weights_sum_Kriging,file=paste0(folder,"/Kriging/Weights_0.05"))
}else print("no important pars")

k=1
d <- D[k]

#AKMCS

load(paste0(folder,"/AKMCS/Rho_0.05"))
all_Rho_AKMCS_node0<- Rho_sum_AKMCS

#BASS

load(paste0(folder,"/BASS_mmESS/Rho_0.05"))
all_Rho_BASS_node0<- Rho_sum_BASS

#Kriging

load(paste0(folder,"/Kriging/Rho_0.05"))
all_Rho_Kriging_node0<- Rho_sum_Kriging


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
  
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/TotSens"))
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/Rank"))
  
  ##############################################################################
  #AKMCS
  
  load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
  
  load(paste0(folder,"/AKMCS/seed",seed,"/TotSens"))
  load(paste0(folder,"/AKMCS/seed",seed,"/Rank"))
  
  importantPars<- which(TotSens>0.05)
  if(length(importantPars)>=1){
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
  save(Rho_sum_AKMCS,Rho_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/Rho_0.05"))
  save(Weights_AKMCS,Weights_sum_AKMCS,file=paste0(folder,"/AKMCS/seed",seed,"/Weights_0.05"))
  }else print("no important pars")
  
  ##############################################################################
  #BASS
  
  load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/S_BASS_list"))
  
  load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/TotSens"))
  load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rank"))
  
  importantPars<- which(TotSens>0.05)
  if(length(importantPars)>=1){
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
  save(Rho_sum_BASS,Rho_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rho_0.05"))
  save(Weights_BASS,Weights_sum_BASS,file=paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Weights_0.05"))
  }else print("no important pars")
  
  ##############################################################################
  #Kriging
  
  load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
  
  load(paste0(folder,"/Kriging/seed",seed,"/TotSens"))
  load(paste0(folder,"/Kriging/seed",seed,"/Rank"))
  
  importantPars<- which(TotSens>0.05)
  if(length(importantPars)>=1){
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
  save(Rho_sum_Kriging,Rho_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/Rho_0.05"))
  save(Weights_Kriging,Weights_sum_Kriging,file=paste0(folder,"/Kriging/seed",seed,"/Weights_0.05"))
  }else print("no important pars")
  
}

all_Rho_AKMCS<-rep(NA,n_nodes)
all_Rho_BASS<-rep(NA,n_nodes)
all_Rho_Kriging<-rep(NA,n_nodes)


for(node in 1:(n_nodes-1)){
  
  print(paste0("node= ",node))
  
  k=1
  d <- D[k]
  
  print(paste0("k= ",k))
  
  seed<- node*10
  seed_Sobol<- node*3
  seed_BASS<- node*2
  
  #AKMCS
  
  load(paste0(folder,"/AKMCS/seed",seed,"/Rho_0.05"))
  all_Rho_AKMCS[node+1]<- Rho_sum_AKMCS
  
  #BASS
  
  load(paste0(folder,"/BASS_mmESS/seed",seed_BASS,"/Rho_0.05"))
  all_Rho_BASS[node+1]<- Rho_sum_BASS
  
  #Kriging
  
  load(paste0(folder,"/Kriging/seed",seed,"/Rho_0.05"))
  all_Rho_Kriging[node+1]<- Rho_sum_Kriging
  
  
}

all_Rho_AKMCS[1]<- all_Rho_AKMCS_node0
all_Rho_BASS[1]<- all_Rho_BASS_node0
all_Rho_Kriging[1]<- all_Rho_Kriging_node0

mean_Rho_AKMCS<- mean(all_Rho_AKMCS)
mean_Rho_BASS<- mean(all_Rho_BASS)
mean_Rho_Kriging<- mean(all_Rho_Kriging)

max_Rho_AKMCS<- max(all_Rho_AKMCS)
max_Rho_BASS<- max(all_Rho_BASS)
max_Rho_Kriging<- max(all_Rho_Kriging)

min_Rho_AKMCS<- min(all_Rho_AKMCS)
min_Rho_BASS<- min(all_Rho_BASS)
min_Rho_Kriging<- min(all_Rho_Kriging)

save(all_Rho_AKMCS,file=paste0(folder,"all_Rho_AKMCS_0.05"))
save(all_Rho_BASS,file=paste0(folder,"all_Rho_BASS_0.05"))
save(all_Rho_Kriging,file=paste0(folder,"all_Rho_Kriging_0.05"))

save(min_Rho_AKMCS,mean_Rho_AKMCS,max_Rho_AKMCS,file=paste0(folder,"/summary_Rho_AKMCS_0.05"))
save(min_Rho_BASS,mean_Rho_BASS,max_Rho_BASS,file=paste0(folder,"/summary_Rho_BASS_0.05"))
save(min_Rho_Kriging,mean_Rho_Kriging,max_Rho_Kriging,file=paste0(folder,"/summary_Rho_Kriging_0.05"))

#weighted average in the difference in ranking of input parameters
