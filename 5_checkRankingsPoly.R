#what are the actual rankings?
#does rank get higher or lower with parameter number?

rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

source("0_libraryPoly.R")

n_nodes<- 4

for(k in 1:(length(D))){
  
  d <- D[k]
  
  allRanksAKMCS<- matrix(NA, nrow= n_nodes, ncol= d)
  allRanksBASS<- matrix(NA, nrow= n_nodes, ncol= d)
  allRanksKriging<- matrix(NA, nrow= n_nodes, ncol= d)
  allRanksSobol<- matrix(NA, nrow= n_nodes, ncol= d)
  
  allTotSensAKMCS<- matrix(NA, nrow= n_nodes, ncol= d)
  allTotSensBASS<- matrix(NA, nrow= n_nodes, ncol= d)
  allTotSensKriging<- matrix(NA, nrow= n_nodes, ncol= d)
  allTotSensSobol<- matrix(NA, nrow= n_nodes, ncol= d)
  
  for(node in 0:(n_nodes-1)){
    
    seed<- k*node
    seed_Sobol<- k*node*10
    
    print(paste0("node= ",node))
    
    ############################################################################
    #Standard Sobol'
    
    if(node==0){
      folder <- paste0(folderpath,d,"D/Sobol")
    } else folder <- paste0(folderpath,d,"D/Sobol/seed",seed_Sobol)

    load(paste0(folder,"/TotSens"))
    load(paste0(folder,"/Rank"))
    
    allRanksSobol[node+1,]<- Rank
    allTotSensSobol[node+1,]<- TotSens
    
    ############################################################################
    #AKMCS
    
    if(node==0){
      folder<-paste0(folderpath,d,"D/AKMCS")
    } else folder<-paste0(folderpath,d,"D/AKMCS/seed",seed)
  
    load(paste0(folder,"/TotSens"))
    load(paste0(folder,"/Rank"))
    
    allRanksAKMCS[node+1,]<- Rank
    allTotSensAKMCS[node+1,]<- TotSens
    
    ############################################################################
    #BASS
    
    if(node==0){
      folder<-paste0(folderpath,d,"D/BASS_mmESS")
    } else folder<-paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
    
    load(paste0(folder,"/TotSens"))
    load(paste0(folder,"/Rank"))
    
    allRanksBASS[node+1,]<- Rank
    allTotSensBASS[node+1,]<- TotSens
    
    ############################################################################
    #Kriging
    
    if(node==0){
      folder<-paste0(folderpath,d,"D/Kriging")
    } else folder<-paste0(folderpath,d,"D/Kriging/seed",seed)
    
    load(paste0(folder,"/TotSens"))
    load(paste0(folder,"/Rank"))
    
    allRanksKriging[node+1,]<- Rank
    allTotSensKriging[node+1,]<- TotSens
 
  }
  
  folder<-paste0(folderpath,d,"D")

  save(allRanksAKMCS,file=paste0(folder,"/allRanksAKMCS"))
  save(allTotSensAKMCS,file=paste0(folder,"/allTotSensAKMCS"))
  
  save(allRanksBASS,file=paste0(folder,"/allRanksBASS"))
  save(allTotSensBASS,file=paste0(folder,"/allTotSensBASS"))
  
  save(allRanksKriging,file=paste0(folder,"/allRanksKriging"))
  save(allTotSensKriging,file=paste0(folder,"/allTotSensKriging"))
  
  save(allRanksSobol,file=paste0(folder,"/allRanksSobol"))
  save(allTotSensSobol,file=paste0(folder,"/allTotSensSobol"))
}
