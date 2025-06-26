#check which of the seeds have not converged

#check 1: do T_check_BASS, T_BASSSobol, and S_BASS exist?
rm(list = ls())
graphics.off()

source("0_libraryPoly.R")

for(k in 1:6){
  for(node in 1:4){
    print(paste0("k= ",k))
    seed<- node*k*10
    print(paste0("seed= ",seed))
    d=D[k]
    
    folder<-paste0(folderpath,"Polynomial/",d,"D/Sobol/seed",seed)
    
    try(load(paste0(folder, "/T_check_Sobol")))
    try(load(paste0(folder,"/T_Sobol")))
    try(load(paste0(folder,"/S_Sobol")))
    try(load(paste0(folder,"/Sobol_convergesize")))
    print(paste0("converge size: ", Sobol_convergesize))
  }
}
#all of them have converged