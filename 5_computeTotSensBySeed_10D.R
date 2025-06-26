#check that the total sensitivity indices converge to the same place
#across all seeds

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

n_nodes=5
D=10

# Total sensitivity for the each parameter under each method & each node
TotSens_Sobol <- matrix(NA,nrow= n_nodes, ncol= D)
TotSens_Kriging <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_AKMCS <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_BASS <- matrix(NA,nrow= n_nodes,ncol= D)

folder <- paste0("./Ranking_Data/10D")

#Sobol
load(paste0(folder,"/Sobol/S_Sobol"))
TS_Sobol<-S$results$original[11:20]
TotSens_Sobol[1,]<- TS_Sobol

#BASS
load(paste0(folder,"/BASS/S_BASS"))
TS_BASS<- c(mean(S_BASS$T$`1`),mean(S_BASS$T$`2`),mean(S_BASS$T$`3`),mean(S_BASS$T$`4`),mean(S_BASS$T$`5`),
            mean(S_BASS$T$`6`),mean(S_BASS$T$`7`),mean(S_BASS$T$`8`),mean(S_BASS$T$`9`),mean(S_BASS$T$`10`))
TotSens_BASS[1,]<- TS_BASS

#Kriging
load(paste0(folder,"/Kriging/S_Kriging"))
TS_Kriging<-S$results$original[11:20]
TotSens_Kriging[1,]<- TS_Kriging

#AKMCS
load(paste0(folder,"/AKMCS/S_AKMCS"))
TS_AKMCS<-S$results$original[11:20]
TotSens_AKMCS[1,]<- TS_AKMCS

for(node in 1:(n_nodes-1)){
  i=3
  seed_Sobol<- i*node*10
  seed<- i*node
  
  #Sobol
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/S_Sobol"))
  TS_Sobol<-S$results$original[11:20]
  TotSens_Sobol[node+1,]<- TS_Sobol
  
  #BASS
  load(paste0(folder,"/BASS/seed",seed,"/S_BASS"))
  TS_BASS<- c(mean(S_BASS$T$`1`),mean(S_BASS$T$`2`),mean(S_BASS$T$`3`),mean(S_BASS$T$`4`),mean(S_BASS$T$`5`))
  TotSens_BASS[node+1,]<- TS_BASS
  
  #Kriging
  load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
  TS_Kriging<-S$results$original[11:20]
  TotSens_Kriging[node+1,]<- TS_Kriging
  
  #AKMCS
  load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
  TS_AKMCS<-S$results$original[11:20]
  TotSens_AKMCS[node+1,]<- TS_AKMCS
  
}

save(TotSens_AKMCS,file=paste0(folder,"/TotSens_AKMCS"))
save(TotSens_BASS,file=paste0(folder,"/TotSens_BASS"))
save(TotSens_Kriging,file=paste0(folder,"/TotSens_Kriging"))
save(TotSens_Sobol,file=paste0(folder,"/TotSens_Sobol"))

