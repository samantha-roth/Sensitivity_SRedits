# Sobol based on the Adaptive Kriging combined with Monte Carlo Sampling (AKMCS) method
# Note: This script also takes an extremely long time when dealing with high-dimensional
#       models. Again change the dimension vector D for code replication check. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

# Set a working directory, please set it to your own working folder when testing
setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

# Load the required packages
source("0_libraryPoly.R")

print("4_20D_diffseeds.R")

#necessary packages for parallelization
library("foreach")
library("doParallel")

#setup parallel backend to use many processors
cores=detectCores()
cl <- makeCluster(cores[1]-1) # -1 not to overload system
registerDoParallel(cl)

#foreach executes the code within the brackets separately on each node
foreach(node = 1:3)%dopar%{ 
  # Define the test model in each dimension, apply AKMCS and perform the Sobol analysis
  k=5
  seed<- node*k
  set.seed(seed)
  
  T_AKMCS<- vector()
  T_pred_AKMCS<- vector()
  T_AKMCSSobol<- vector()
  T_check_AKMCS<- vector()
  T_model_AKMCS<- vector()
  
  # model dimension
  d <- D[k]
  
  folder<-paste0(folderpath,d,"D/AKMCS/seed",seed) #set folder depending on both d and node
  if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
  
  
  # Start recording the time from AKMCS initial state
  # AKMCS also begins with 20,000 training samples
  start.time <- Sys.time()
  
  
  candidate_size <- 20000
  X <- randomLHS(candidate_size,d)
  
  # Save these training samples
  save(X,file = paste0(folder,"/initial_sample"))
  
  # Begin with 12 random samples from these training samples
  n_init <- 10 + d
  indx <- sample(candidate_size,n_init)
  AKMCS_size_vec<- n_init
  AKMCS_size<- n_init
  
  # Update the used samples and remaining samples
  x <- X[indx, ]
  x_rest <- X[-indx, ]
  
  # Evaluate model outputs and fit a Kriging model
  start.time<- Sys.time()
  y <- apply(x,1,Testmodel)
  end.time<- Sys.time()
  model_time<- difftime(end.time,start.time,units = "secs")
  T_model_AKMCS<- c(T_model_AKMCS,model_time)
  
  start.time<- Sys.time()
  GPmodel <- GP_fit(x, y)
  end.time<- Sys.time()
  fit_time<- difftime(end.time,start.time,units = "secs")
  T_AKMCS<- c(T_AKMCS,fit_time)
  
  start.time<- Sys.time()
  a <- predict(GPmodel,x_rest)
  end.time<- Sys.time()
  pred_time<- difftime(end.time,start.time,units = "secs")
  T_pred_AKMCS<- c(T_pred_AKMCS,pred_time)
  
  # U is the learning function, which is simply the standard error here
  U <- sqrt(a$MSE)
  print(paste0("sample size =",dim(x)[1], "max(U) =",max(U),"range = ",(max(a$Y_hat)-min(a$Y_hat))/20))
  
  
  save(AKMCS_size,file = paste0(folder,"/AKMCS_size"))
  save(AKMCS_size_vec,file = paste0(folder,"/AKMCS_size_vec"))
  save(T_AKMCS,file = paste0(folder,"/T_AKMCS"))
  save(T_model_AKMCS,file = paste0(folder,"/T_model_AKMCS"))
  save(T_pred_AKMCS,file = paste0(folder,"/T_pred_AKMCS"))
  save(x,file = paste0(folder,"/x"))
  save(a,file = paste0(folder,"/a"))
  
  # End the loop if the stopping criterion is fulfilled
  # Stopping criterion: all the remaining samples have standard errors larger than 1
  # If the criterion is not reached, pick the next sample adaptively based on the learning function
  if (max(U)>(max(a$Y_hat)-min(a$Y_hat))/20){
    while (1>0){
      
      # Find which sample has the largest standard error
      m <- which(U==max(U))
      if (length(m)>1){
        m <- sample(m,1)
      }
      
      # Add that sample and update the remaining samples
      x_add <- x_rest[m, ]
      x_rest <- x_rest[-m, ]
      
      # Evaluate the output of that sample and update
      start.time<- Sys.time()
      y_add <- Testmodel(x_add)
      end.time<- Sys.time()
      model_time<- difftime(end.time,start.time,units = "secs")
      T_model_AKMCS<- c(T_model_AKMCS,model_time)
      
      y <- append(y,y_add)
      x <- rbind(x,x_add)
      
      # Fit the Kriging model again
      start.time<- Sys.time()
      GPmodel <- GP_fit(x, y)
      end.time <- Sys.time()
      fit_time <- difftime(end.time,start.time, units = "secs")
      T_AKMCS<- c(T_AKMCS,fit_time)
      
      start.time<- Sys.time()
      a <- predict(GPmodel,x_rest)
      end.time <- Sys.time()
      pred_time <- difftime(end.time,start.time, units = "secs")
      T_pred_AKMCS<- c(T_pred_AKMCS,pred_time)
      
      # Get the learning function again
      U <- sqrt(a$MSE)
      print(paste0("sample size =",dim(x)[1], "max(U) =",max(U),"range = ",(max(a$Y_hat)-min(a$Y_hat))/20))
      
      AKMCS_size<- AKMCS_size+1
      AKMCS_size_vec<- c(AKMCS_size_vec,AKMCS_size)
      
      save(AKMCS_size,file = paste0(folder,"/AKMCS_size"))
      save(AKMCS_size_vec,file = paste0(folder,"/AKMCS_size_vec"))
      save(T_AKMCS,file = paste0(folder,"/T_AKMCS"))
      save(T_model_AKMCS,file = paste0(folder,"/T_model_AKMCS"))
      save(T_pred_AKMCS,file = paste0(folder,"/T_pred_AKMCS"))
      save(x,file = paste0(folder,"/x"))
      save(a,file = paste0(folder,"/a"))
      
      
      # End the loop if the stopping criterion is fulfilled
      if (max(U)<(max(a$Y_hat)-min(a$Y_hat))/20){
        break
      }
    }
  }
  
  T_AKMCSSobol<- vector()
  T_check_AKMCS<- vector()
  for (m in 1:length(tot_size)){
    
    # Next perform the sensitivity analysis
    N <- floor(tot_size[m]/(d+2+d*(d-1)/2))
    
    if(N>=2){
      Sobol_AKMCS_convergesize<- tot_size[m]
      print(paste0("checking convergence of input ranking at a sample size of ", tot_size[m]))
      
      # Time for sensitivity analysis
      start.time <- Sys.time()
      
      mat <- sobol_matrices(N = N, params = as.character(c(1:d)), order = "second")
      
      Y_S <- Kriging(mat)
      
      S_AKMCS <- sobol_indices_boot(Y=Y_S,N=N,params = as.character(c(1:d)),
                                    boot=TRUE,R=nboot,order="second")
      
      end.time<-Sys.time()
      time_sobol<- difftime(end.time,start.time,units = "secs")
      T_AKMCSSobol<-c(T_AKMCSSobol,time_sobol)
      
      # convergence of ranking:
      
      start.time <- Sys.time()
      
      Sens <- S_AKMCS$boot$t[ ,c((1+d):(2*d))]
      Rank <- t(apply(Sens, 1, rank))
      for (boot_ind1 in 1:(nboot-1)){
        T <- boot_ind1
        for (boot_ind2 in (T+1):nboot){
          Rho <- rep(NA,d)
          Weights <- rep(NA,d)
          for (para_ind in 1:d){
            Weights[para_ind] <- (max(Sens[boot_ind1,para_ind],max(Sens[boot_ind2,para_ind])))^2
          }
          Weights_sum <- sum(Weights)
          for (para_ind in 1:d){
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
      Rho_all <- matrix(Rho_all, nrow = d)
      Rho_all <- apply(Rho_all, 2, sum)
      
      end.time <- Sys.time()
      time_check <- difftime(end.time,start.time,units = "secs")
      T_check_AKMCS<- c(T_check_AKMCS,time_check)
      
      save(T_AKMCSSobol,file = paste0(folder,"/T_AKMCSSobol"))
      save(T_check_AKMCS,file=paste0(folder,"/T_check_AKMCS"))
      save(S_AKMCS,file=paste0(folder,"/S_AKMCS"))
      save(Sobol_AKMCS_convergesize,file=paste0(folder,"/Sobol_AKMCS_convergesize"))
      
      if (!any(is.na(Rho_all))){
        #print(quantile(Rho_all,probs = 0.95, na.rm = TRUE))
        if (quantile(Rho_all,probs = 0.95, na.rm = TRUE) < 1){
          break
        } 
      }
    }
  }
  
}