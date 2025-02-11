# This script prepares the required data of Figure 5 in the paper
# Show the sensitivity indices's ranking's convergence

# Remove all existing environment and plots
rm(list = ls())
graphics.off()
source("0_library.R")

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

# Plot the results in the example of 5D problem
d<-5
folder<-paste("./Ranking_Data/",d,"D/Traceplot_rank",sep="")

# Test model in 5D
Testmodel<-function (X) {
  a = rep(NA,d)
  for (i in 1:d){
    a[i] <- i
  }
  
  up <- abs(4*X-2) + a
  down <- 1 + a
  prod <- prod(up/down)
  
  return(prod)
}


# Sizes used for Sobol trace plot
# Standard Sobol's results do not vary by random seeds, other methods' results do. 
Size_S <- c(seq(40,1000,by=40),seq(1000,5000,by=1000))
T_S <- matrix(NA, nrow=5,ncol=length(Size_S))


# Sizes used for Kriging traceplot
# 5 different seeds for the emulation methods
Size_K <- c(5:10,seq(12,100,by=2))

# Total-order indices
T_K <- matrix(NA,nrow=5,ncol=length(Size_K))

# Sizes used for AKMCS traceplot
Size_A <- c(3:100)
T_A <- matrix(NA,nrow=5,ncol=length(Size_A))

# Sizes used for BASS traceplot
Size_B <- c(5:10,seq(12,100,by=2))
T_B <- matrix(NA,nrow=5,ncol=length(Size_B))

# Test for 5 seeds for the emulation methods
set.seed(1)


# BASS method simply takes different initial sample sizes
for (i in 1:length(Size_B)){
  X <- randomLHS(Size_B[i], d)
  Y <- apply(X, 1, Testmodel)
  mcmc_size <- 500000
  mod <- bass(X, Y, nmcmc = mcmc_size, nburn = 100000, thin = 1000,verbose = FALSE) # fit BASS model
  S_BASS <- sobol(mod, verbose = FALSE)
  # Take the mean of the ensemble as the best estimate
  T_B[ ,i] <- colMeans(S_BASS$T)
}
save(T_B,file = paste(folder,"/T_B",sep=""))