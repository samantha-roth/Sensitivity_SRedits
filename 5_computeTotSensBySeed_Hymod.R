
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
D=5

# Total sensitivity for the each parameter under each method & each node
TotSens_Sobol <- matrix(NA,nrow= n_nodes, ncol= D)
TotSens_Kriging <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_AKMCS <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_BASS <- matrix(NA,nrow= n_nodes,ncol= D)
#95% CI lower bounds
TotSens_Sobol_lo <- matrix(NA,nrow= n_nodes, ncol= D)
TotSens_Kriging_lo <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_AKMCS_lo <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_BASS_lo <- matrix(NA,nrow= n_nodes,ncol= D)
#95% CI upper bounds
TotSens_Sobol_hi <- matrix(NA,nrow= n_nodes, ncol= D)
TotSens_Kriging_hi <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_AKMCS_hi <- matrix(NA,nrow= n_nodes,ncol= D)
TotSens_BASS_hi <- matrix(NA,nrow= n_nodes,ncol= D)


folder <- paste0("./Ranking_Data/Hymod")

#Sobol
load(paste0(folder,"/Sobol/S_Sobol"))
TS_Sobol<-S$results$original[6:10]
TS_Sobol.025<-S$results$low.ci[6:10]
TS_Sobol.975<-S$results$high.ci[6:10]
TotSens_Sobol[1,]<- TS_Sobol
TotSens_Sobol_lo[1,]<- TS_Sobol.025
TotSens_Sobol_hi[1,]<- TS_Sobol.975

#BASS
load(paste0(folder,"/BASS/S_BASS"))
TS_BASS<- c(mean(S_BASS$T$`1`),mean(S_BASS$T$`2`),mean(S_BASS$T$`3`),mean(S_BASS$T$`4`),mean(S_BASS$T$`5`))
TS_BASS.025<- c(as.numeric(quantile(S_BASS$T$`1`,.025)),as.numeric(quantile(S_BASS$T$`2`,.025)),
                as.numeric(quantile(S_BASS$T$`3`,.025)),as.numeric(quantile(S_BASS$T$`4`,.025)),as.numeric(quantile(S_BASS$T$`5`,.025)))
TS_BASS.975<- c(as.numeric(quantile(S_BASS$T$`1`,.975)),as.numeric(quantile(S_BASS$T$`2`,.975)),
                as.numeric(quantile(S_BASS$T$`3`,.975)),as.numeric(quantile(S_BASS$T$`4`,.975)),as.numeric(quantile(S_BASS$T$`5`,.975)))
TotSens_BASS[1,]<- TS_BASS
TotSens_BASS_lo[1,]<- TS_BASS.025
TotSens_BASS_hi[1,]<- TS_BASS.975

#Kriging
load(paste0(folder,"/Kriging/S_Kriging"))
TS_Kriging<-S_Kriging$results$original[6:10]
TS_Kriging.025<-S_Kriging$results$low.ci[6:10]
TS_Kriging.975<-S_Kriging$results$high.ci[6:10]
TotSens_Kriging[1,]<- TS_Kriging
TotSens_Kriging_lo[1,]<- TS_Kriging.025
TotSens_Kriging_hi[1,]<- TS_Kriging.975

#AKMCS
load(paste0(folder,"/AKMCS/S_AKMCS"))
TS_AKMCS<-S_AKMCS$results$original[6:10]
TS_AKMCS.025<-S_AKMCS$results$low.ci[6:10]
TS_AKMCS.975<-S_AKMCS$results$high.ci[6:10]
TotSens_AKMCS[1,]<- TS_AKMCS
TotSens_AKMCS_lo[1,]<- TS_AKMCS.025
TotSens_AKMCS_hi[1,]<- TS_AKMCS.975

for(node in 1:(n_nodes-1)){
  seed<- node*10
  seed_Sobol<- node*3
  
  #Sobol
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/S_Sobol"))
  TS_Sobol<-S$results$original[6:10]
  TS_Sobol.025<-S$results$low.ci[6:10]
  TS_Sobol.975<-S$results$high.ci[6:10]
  TotSens_Sobol[node+1,]<- TS_Sobol
  TotSens_Sobol_lo[node+1,]<- TS_Sobol.025
  TotSens_Sobol_hi[node+1,]<- TS_Sobol.975
  
  #BASS
  load(paste0(folder,"/BASS/seed",seed,"/S_BASS"))
  TS_BASS<- c(mean(S_BASS$T$`1`),mean(S_BASS$T$`2`),mean(S_BASS$T$`3`),mean(S_BASS$T$`4`),mean(S_BASS$T$`5`))
  TS_BASS.025<- c(as.numeric(quantile(S_BASS$T$`1`,.025)),as.numeric(quantile(S_BASS$T$`2`,.025)),
                  as.numeric(quantile(S_BASS$T$`3`,.025)),as.numeric(quantile(S_BASS$T$`4`,.025)),as.numeric(quantile(S_BASS$T$`5`,.025)))
  TS_BASS.975<- c(as.numeric(quantile(S_BASS$T$`1`,.975)),as.numeric(quantile(S_BASS$T$`2`,.975)),
                  as.numeric(quantile(S_BASS$T$`3`,.975)),as.numeric(quantile(S_BASS$T$`4`,.975)),as.numeric(quantile(S_BASS$T$`5`,.975)))
  TotSens_BASS[node+1,]<- TS_BASS
  TotSens_BASS_lo[node+1,]<- TS_BASS.025
  TotSens_BASS_hi[node+1,]<- TS_BASS.975
  
  #Kriging
  load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
  TS_Kriging<-S_Kriging$results$original[6:10]
  TS_Kriging.025<-S_Kriging$results$low.ci[6:10]
  TS_Kriging.975<-S_Kriging$results$high.ci[6:10]
  TotSens_Kriging[node+1,]<- TS_Kriging
  TotSens_Kriging_lo[node+1,]<- TS_Kriging.025
  TotSens_Kriging_hi[node+1,]<- TS_Kriging.975
  
  #AKMCS
  load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
  TS_AKMCS<-S_AKMCS$results$original[6:10]
  TS_AKMCS.025<-S_AKMCS$results$low.ci[6:10]
  TS_AKMCS.975<-S_AKMCS$results$high.ci[6:10]
  TotSens_AKMCS[node+1,]<- TS_AKMCS
  TotSens_AKMCS_lo[node+1,]<- TS_AKMCS.025
  TotSens_AKMCS_hi[node+1,]<- TS_AKMCS.975
}

save(TotSens_AKMCS,TotSens_AKMCS_lo,TotSens_AKMCS_hi,file=paste0(folder,"/TotSens_AKMCS"))
save(TotSens_BASS,TotSens_BASS_lo,TotSens_BASS_hi,file=paste0(folder,"/TotSens_BASS"))
save(TotSens_Kriging,TotSens_Kriging_lo,TotSens_Kriging_hi,file=paste0(folder,"/TotSens_Kriging"))
save(TotSens_Sobol,TotSens_Sobol_lo,TotSens_Sobol_hi,file=paste0(folder,"/TotSens_Sobol"))

for(node in 1:n_nodes){
  for(par in 1:D){
    print(paste0("node: ",node))
    print(paste0("par: ",par))
    print(paste0("AKMCS CI width: ", TotSens_AKMCS_hi[node,par]-TotSens_AKMCS_lo[node,par]))
    print(paste0("BASS CI width: ", TotSens_BASS_hi[node,par]-TotSens_BASS_lo[node,par]))
    print(paste0("Kriging CI width: ", TotSens_Kriging_hi[node,par]-TotSens_Kriging_lo[node,par]))
    print(paste0("Sobol CI width: ", TotSens_Sobol_hi[node,par]-TotSens_Sobol_lo[node,par]))
  }
}

#The CI widths tend to be a lot more variable for AKMCS, Kriging and Sobol than for BASS
#sometimes very large, sometimes essentially zero. BASS's are pretty consistently <0.1
