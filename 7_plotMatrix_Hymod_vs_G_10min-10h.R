#get total times for different seeds

# This script makes grid plots not included in the original analysis
# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

library(ggplot2)
library(gridExtra)
library(grid)

source("0_libraryHymod.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#load Hymod results
folder<- paste0(folderpath,"Hymod")
load(paste0(folder,"/Time_Sobol_arr"))
load(paste0(folder,"/Time_BASS_arr"))
load(paste0(folder,"/Time_Kriging_arr"))
load(paste0(folder,"/Time_AKMCS_arr"))

Time_Sobol_Hymod<- Time_Sobol_arr[1,,]
Time_BASS_Hymod<- Time_BASS_arr[1,,]
Time_Kriging_Hymod<- Time_Kriging_arr[1,,]
Time_AKMCS_Hymod<- Time_AKMCS_arr[1,,]

load(paste0("./Ranking_Data/Time_Sobol_arr"))
load(paste0("./Ranking_Data/Time_BASS_arr"))
load(paste0("./Ranking_Data/Time_Kriging_arr"))
load(paste0("./Ranking_Data/Time_AKMCS_arr"))

Time_Sobol_G<- Time_Sobol_arr[which(tested_D=="5D"),,]; rm(Time_Sobol_arr)
Time_BASS_G<- Time_BASS_arr[which(tested_D=="5D"),,]; rm(Time_BASS_arr)
Time_Kriging_G<- Time_Kriging_arr[which(tested_D=="5D"),,]; rm(Time_Kriging_arr)
Time_AKMCS_G<- Time_AKMCS_arr[which(tested_D=="5D"),,]; rm(Time_AKMCS_arr)

n_nodes<- dim(Time_AKMCS_Hymod)[2]
n_modeltimes<- dim(Time_AKMCS_Hymod)[1]

create_plot <- function(modeltime,model) {
  
  if(model=="Hymod"){
    # Create a data frame
    df <- data.frame(
      Method = rep(c("Sobol", "BASS", "Kriging", "AKMCS"), each = n_nodes),
      SA_Time = c(
        Time_Sobol_Hymod[modeltime,]/3600/24,  
        Time_BASS_Hymod[modeltime,]/3600/24,  
        Time_Kriging_Hymod[modeltime,]/3600/24,  
        Time_AKMCS_Hymod[modeltime,]/3600/24
      )
    )
    title<- NULL
  }
  
  if(model=="G"){
    # Create a data frame
    df <- data.frame(
      Method = rep(c("Sobol", "BASS", "Kriging", "AKMCS"), each = n_nodes),
      SA_Time = c(
        Time_Sobol_G[modeltime,]/3600/24,  
        Time_BASS_G[modeltime,]/3600/24,  
        Time_Kriging_G[modeltime,]/3600/24,  
        Time_AKMCS_G[modeltime,]/3600/24
      )
    )
    title<- eval_time_lab[modeltime]
  }
  
  if(eval_time_lab[modeltime]=="10min") ylab<- "Sensitivity Analysis Time (days)"
  if(eval_time_lab[modeltime]=="1h") ylab<- NULL
  if(eval_time_lab[modeltime]=="10h") ylab<- NULL
  
  # Create the plot
  ggplot(df, aes(x = Method, y = SA_Time, color=Method)) +
    geom_point(position = position_dodge(width = 0), alpha = 0.7) +
    labs(title= title,
         x = NULL,
         y = ylab) +
    theme_minimal()+ 
    theme(plot.title = element_text(size=18), 
          axis.title = element_text(size=18),
          axis.text = element_text(size=16),
          #panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          legend.position="none")
}

#times 10min to 10h
# Create plots
G_plots <- list(
  create_plot(7,"G"),
  create_plot(8,"G"),
  create_plot(9,"G")
)

Hymod_plots <- list(
  create_plot(7,"Hymod"),
  create_plot(8,"Hymod"),
  create_plot(9,"Hymod")
)


# Arrange plots with labels
g <- grid.arrange(
  # Top row (G function)
  textGrob("G function", rot = 90, gp = gpar(fontsize = 22)),
  arrangeGrob(grobs = G_plots[1:3], ncol = 3),
  
  # Bottom row (Hymod)
  textGrob("Hymod", rot = 90, gp = gpar(fontsize = 22)),
  arrangeGrob(grobs = Hymod_plots[1:3], ncol = 3),
  
  ncol = 2,  # Two columns: labels and plots
  widths = c(1, 10)  # Adjust width ratio of label column to plot column
)

# Display the plot
filename<- "New_Figures/plotMatrix_Hymod_vs_G_10min-10h.jpeg"
jpeg(file = filename,width = 1000,height=600,type="cairo")
grid.draw(g)
dev.off()