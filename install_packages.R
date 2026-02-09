# Remove all existing environment and plots
rm(list = ls())
graphics.off()

# Set a working directory, please set it to your own working folder when testing
setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")
# dir<- commandArgs(trailingOnly=TRUE)
# setwd(dir)

install.packages("sensobol")
install.packages("lhs")
install.packages("BASS")
install.packages("mcmcse")
install.packages("GPfit")