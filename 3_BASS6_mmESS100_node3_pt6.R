# Sobol based on the Bayesian Adaptive Spline Surface (BASS) method
# Note: the Sobol analysis in this script directly uses the function in "BASS" package instead of sensobol package

# This script also takes a time when dealing with high-dimensional models (but not extremely long).
#       Again change the dimension vector D for code replication check.
# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")
source("bass_mcmc_size.R")
source("check_T_convergence.R")

print("3_BASS6_mmESS100_node3_pt6.R")

# Define the model in each dimension and apply BASS method
k=6

# Model dimension
d=D[k]

node=3

seed<- node*k
set.seed(seed)

# Folder for d dimension test scenario
folder <- paste0(folderpath,d,"D/BASS_mmESS/seed",seed)
if (!dir.exists(folder)) dir.create(file.path(folder), showWarnings = FALSE)

load(paste0(folder, "/X_BASS"))
load(paste0(folder, "/T_BASS"))
load(paste0(folder, "/T_model_BASS"))
load(paste0(folder, "/T_LHS_BASS"))
load(paste0(folder, "/T_pred_BASS"))
load(paste0(folder, "/BASS_size_vec"))
load(paste0(folder, "/BASS_size"))
load(paste0(folder,"/x_test"))

if(file.exists(paste0(folder,"/T_BASSSobol"))){
  load(paste0(folder,"/T_BASSSobol"))
} else T_BASSSobol<- vector()

if(file.exists(paste0(folder,"/T_check_BASS"))){
  load(paste0(folder,"/T_check_BASS"))
} else T_check_BASS<- vector()

n_empars<- d*10+4
nthin<-n_empars
burn_size<-n_empars
mcmc_init_size <- ceiling(2e5/n_empars)*n_empars+n_empars*1e3+burn_size
wantESS<-100
nwant_pred<- 1e4
nwant_T<- 100


Y <- apply(X_BASS, 1, Testmodel)

load(paste0(folder,"/tot_steps"))
load(paste0(folder,"/par_chain"))
load(paste0(folder,"/cs_steps"))
load(paste0(folder,"/mESS"))
load(paste0(folder,"/mod_list"))
load(paste0(folder, "/T_BASS"))

y<- matrix(NA,nrow=1,ncol=nrow(x_test))
for(i in 1:length(mod_list)){
  mod_i<- mod_list[[i]]
  
  valid_steps<- which(mod_i$model.lookup>0)
  
  y<- rbind(y,predict(mod_i,x_test,mcmc.use= valid_steps))
}
y<- y[-1,]

std <- sqrt(apply(y, 2, var)); print("std done")
mean <- colMeans(y)
print(paste0("sample size = ",BASS_size))
print(paste0("max std = ",max(std), ", thres value = ", (max(mean)-min(mean))/20))

check_T_out<- check_T_convergence(mod_list=mod_list, burn_size=burn_size, nthin=nthin, nwant_T=nwant_T)

mod_list<- check_T_out[[1]]
S_BASS_list<- check_T_out[[2]]
T_BASSSobol<- check_T_out[[3]]
T_check_BASS<- check_T_out[[4]]

save(mod_list,file=paste0(folder,"/mod_list"))
save(T_check_BASS, file = paste0(folder, "/T_check_BASS"))
save(T_BASSSobol,file = paste0(folder,"/T_BASSSobol"))
save(S_BASS_list,file = paste0(folder,"/S_BASS_list"))
