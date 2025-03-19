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
    
    folder<-paste0(folderpath,d,"D/AKMCS/seed",seed)
    
    try(load(paste0(folder, "/T_check_AKMCS")))
    try(load(paste0(folder,"/T_AKMCSSobol")))
    try(load(paste0(folder,"/S_AKMCS")))
    try(load(paste0(folder,"/Sobol_AKMCS_convergesize")))
  }
}
#none of them have converged for k=6
#seed 15 hasn't converged for k=5