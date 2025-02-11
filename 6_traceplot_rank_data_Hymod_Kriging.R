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
# Kriging
for (i in 1:length(Size_K)){
  # Take the corresponding sample size, fit a Kriging model and perform Sobol analysis
  X_GP <- randomLHS(Size_K[i],d)
  Y_GP <- apply(Mapping(X_GP,Range),1,Testmodel)
  GPmodel <- GP_fit(X_GP,Y_GP)
  mat <- sobol_matrices(N = 1000, params = as.character(c(1:d)), order = "second")
  Y_K <- Kriging(mat)
  S <- sobol_indices(Y = Y_K, N = 1000, params = as.character(c(1:d)),
                     boot = TRUE, R = 100,order="second")
  T_K[ ,i] <- S$results$original[6:10]
}
# Save the results of the best estimates
save(T_K,file = paste(folder,"/T_K",sep=""))


