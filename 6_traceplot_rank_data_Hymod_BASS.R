# This script prepares the required data of Figure 6 in the paper
# Show the sensitivity indices's ranking's convergence

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")
source("0_libraryHymod.R")

d<-5

folder<-"./Ranking_Data/Hymod"
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

set.seed(6)


# BASS method simply takes different initial sample sizes
for (i in 1:length(Size_B)){
  X <- randomLHS(Size_B[i], d)
  X <- Mapping(X,Range)
  Y <- apply(X, 1, Testmodel)
  mcmc_size <- 500000
  mod <- bass(X, Y, nmcmc = mcmc_size, nburn = 100000, thin = 1000,verbose = FALSE) # fit BASS model
  S_BASS <- sobol(mod, verbose = FALSE)
  # Take the mean of the ensemble as the best estimate
  T_B[ ,i] <- colMeans(S_BASS$T)
}
save(T_B,file = paste(folder,"/T_B",sep=""))

