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

#Evaluate the results of the standard Sobol method
for (i in 1:length(Size_S)){
  N <- floor(Size_S[i]/(d+2+d*(d-1)/2))
  mat <- sobol_matrices(N = N, params = as.character(c(1:d)), order = "second")
  mat <- Mapping(mat,Range)
  X <- split(t(mat), rep(1:dim(mat)[1], each = d))
  Y <- sapply(X, Testmodel)
  S <- sobol_indices(Y = Y, N = N, params = as.character(c(1:d)),
                     boot = TRUE, R = 100, order = "second")
  T_S[ ,i] <- S$results$original[6:10]
}
save(T_S,file = paste(folder,"/T_S",sep=""))

