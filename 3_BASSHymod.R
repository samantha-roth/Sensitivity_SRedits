# Sobol based on the Bayesian Adaptive Spline Surface (BASS) method
# Note: the Sobol analysis in this script directly uses the function in "BASS" package instead of sensobol package

# This script also takes a time when dealing with high-dimensional models (but not extremely long).
#       Again change the dimension vector D for code replication check.
# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_libraryHymod.R")

print("3_BASSHymod_SR.R")

# Set a random seed
set.seed(31)

# Define the model in each dimension and apply BASS method
T_LHS_BASS<- vector()
T_model_BASS<- vector()
T_BASS<- vector()
T_pred_BASS<- vector()
T_BASSSobol<- vector()
T_check_BASS<- vector()

# Model dimension
d=5
S_total <- rep(NA,d)

folder <- paste(folderpath,"Hymod/BASS",sep="") 
if (!dir.exists(folder)) dir.create(file.path(folder), showWarnings = FALSE)

# Use 20,000 LHS training data points to test emulator quality
x_test <- randomLHS(2e4,d)
#x_test <- Mapping(x_test,Range)      

BASS_size <- 10*d
BASS_size_vec <- BASS_size

# Similar to Kriging method, we begin with 10 times model dimension samples

while (1>0) {
  if(length(BASS_size_vec)==1){
    start.time<- Sys.time()
    X_01 <- randomLHS(BASS_size, d)
    end.time<- Sys.time()
    LHS_time <- difftime(end.time,start.time, units = "secs")
    T_LHS_BASS<- c(T_LHS_BASS,LHS_time)
  }
  if(length(BASS_size_vec)>1){
    start.time<- Sys.time()
    X_01 <- augmentLHS(X_01,d)
    end.time<- Sys.time()
    LHS_time <- difftime(end.time,start.time, units = "secs")
    T_LHS_BASS<- c(T_LHS_BASS,LHS_time)
  }
  
  X_BASS <- Mapping(X_01,Range)      
  
  start.time<- Sys.time()
  Y <- apply(X_BASS, 1, Testmodel)
  end.time <- Sys.time()
  model_time <- difftime(end.time,start.time, units = "secs")
  T_model_BASS<- c(T_model_BASS,model_time)
  
  # Use a MCMC size of 500,000, burn-in period of 100,000, record the output every 1,000 steps
  mcmc_size <- 5e5
  # Record the time of BASS emulation
  start.time <- Sys.time()
  mod <- bass(X_01, Y, nmcmc = mcmc_size, nburn = 1e5, thin = 1e3,verbose = FALSE) # fit BASS model
  end.time <- Sys.time()
  fit_time <- difftime(end.time,start.time, units = "secs")
  T_BASS<- c(T_BASS,fit_time)
  
  start.time<- Sys.time()
  y <- predict(mod,x_test)
  end.time<- Sys.time()
  pred_time<- difftime(end.time,start.time, units = "secs")
  T_pred_BASS<- c(T_pred_BASS, pred_time)
  
  std <- sqrt(apply(y, 2, var))
  mean <- colMeans(y)
  print(paste0("sample size = ",BASS_size))
  print(paste0("max std = ",max(std), ", thres value = ", (max(mean)-min(mean))/20))
  
  save(X_BASS, file = paste0(folder, "/X_BASS"))
  save(X_01, file = paste0(folder, "/X_01"))
  save(T_model_BASS, file = paste0(folder,"/T_model_BASS"))
  save(T_LHS_BASS, file = paste0(folder, "/T_LHS_BASS"))
  save(T_BASS, file = paste0(folder, "/T_BASS"))
  save(T_pred_BASS, file = paste0(folder, "/T_pred_BASS"))
  save(BASS_size,file = paste0(folder,"/BASS_size"))
  save(BASS_size_vec,file = paste0(folder,"/BASS_size_vec"))
  
  # If still need to take more samples, add the sample size by d
  if (max(std) > ((max(mean)-min(mean))/20)){
    BASS_size <- BASS_size + d
    BASS_size_vec<- c(BASS_size_vec,BASS_size)
  }
  # otherwise perform sensitivity analysis and record the time
  else{
    start.time <- Sys.time()
    S_BASS <- sobol(mod, verbose = FALSE)
    end.time <- Sys.time()
    time_sobol <- difftime(end.time,start.time,units = "secs")
    T_BASSSobol<- c(T_BASSSobol,time_sobol)
    
    start.time <- Sys.time()
    Important_indices <- as.numeric(names(S_BASS$T[1, ]))
    
    for (j in 1:length(Important_indices)){
      S_total[Important_indices[j]] <- quantile(S_BASS$T[ ,j],probs = 0.975) - quantile(S_BASS$T[ ,j],probs = 0.025)
    }
    
    # Because we are not using sensobol package here, we need an additional convergence check for the Sobol
    #     analysis. Usually if the emulator's quality is good enough, the sensitivity analysis results should
    #     be stable. We add a convergence check here to make sure the results are reliable. If the results are 
    #     not converged, add the BASS sample size by d.
    
    # If converged, save the emulation time, sensitivity analysis time, sensitivity indices and the sample size
    Sens <- S_BASS$T[seq(4,400,by=4),c(1:length(Important_indices))]
    Rank <- t(apply(Sens, 1, rank))
    for (boot_ind1 in 1:99){
      T <- boot_ind1
      for (boot_ind2 in (T+1):100){
        Rho <- rep(NA,length(Important_indices))
        Weights <- rep(NA,length(Important_indices))
        for (para_ind in 1:length(Important_indices)){
          Weights[para_ind] <- (max(Sens[boot_ind1,para_ind],max(Sens[boot_ind2,para_ind])))^2
        }
        Weights_sum <- sum(Weights)
        for (para_ind in 1:length(Important_indices)){
          Rho[para_ind] <- abs(Rank[boot_ind1,para_ind]-Rank[boot_ind2,para_ind])*
            Weights[para_ind]/Weights_sum
        }
        if (boot_ind2 == 2){
          Rho_all <- Rho
        } else{
          Rho_all <- append(Rho_all,Rho)
        }
      }
    }
    Rho_all <- matrix(Rho_all, nrow = length(Important_indices))
    Rho_all <- apply(Rho_all, 2, sum)
    
    end.time <- Sys.time()
    time_check <- difftime(end.time,start.time,units = "secs")
    T_check_BASS<- c(T_check_BASS,time_check)
    
    save(T_check_BASS, file = paste0(folder, "/T_check_BASS"))
    save(T_BASSSobol,file = paste0(folder,"/T_BASSSobol"))
    save(S_BASS,file = paste0(folder,"/S_BASS"))
    
    if (quantile(Rho_all,probs = 0.95, na.rm = TRUE) < 1){
      break
    } else{
      BASS_size <- BASS_size + d
      BASS_size_vec<- c(BASS_size_vec,BASS_size)
    }
  }
}

