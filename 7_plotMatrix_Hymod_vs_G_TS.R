#get total times for different seeds

# This script makes grid plots not included in the original analysis
# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

library(ggplot2)
library(gridExtra)
library(grid)

source("0_library.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

folder <- paste0("./Ranking_Data")

#Sobol's G function
#load total sensitivity indices for each parameter and each seed using each method
load(paste0(folder,"/5D/TotSens_AKMCS"))
load(paste0(folder,"/5D/TotSens_BASS"))
load(paste0(folder,"/5D/TotSens_Kriging"))
load(paste0(folder,"/5D/TotSens_Sobol"))

TotSens_AKMCS_G<- TotSens_AKMCS
TotSens_BASS_G<- TotSens_BASS
TotSens_Kriging_G<- TotSens_Kriging
TotSens_Sobol_G<- TotSens_Sobol

#Hymod
#load total sensitivity indices for each parameter and each seed using each method
load(paste0(folder,"/Hymod/TotSens_AKMCS"))
load(paste0(folder,"/Hymod/TotSens_BASS"))
load(paste0(folder,"/Hymod/TotSens_Kriging"))
load(paste0(folder,"/Hymod/TotSens_Sobol"))

TotSens_AKMCS_Hymod<- TotSens_AKMCS
TotSens_BASS_Hymod<- TotSens_BASS
TotSens_Kriging_Hymod<- TotSens_Kriging
TotSens_Sobol_Hymod<- TotSens_Sobol

n_nodes<- 5
D=5

create_plot <- function(par,model) {
  
  if(model=="Hymod"){
    # Create a data frame
    df <- data.frame(
      Method = rep(c("Sobol", "BASS", "Kriging", "AKMCS"), each = n_nodes),
      TotSens = c(
        TotSens_Sobol_Hymod[,par],  
        TotSens_BASS_Hymod[,par],  
        TotSens_Kriging_Hymod[,par],  
        TotSens_AKMCS_Hymod[,par]
      )
    )
    title<- NULL
  }
  
  if(model=="G"){
    # Create a data frame
    df <- data.frame(
      Method = rep(c("Sobol", "BASS", "Kriging", "AKMCS"), each = n_nodes),
      TotSens = c(
        TotSens_Sobol_G[,par],  
        TotSens_BASS_G[,par],  
        TotSens_Kriging_G[,par],  
        TotSens_AKMCS_G[,par]
      )
    )
    title<- paste0("Parameter ",par)
  }
  
  if(par==1) ylab<- "Total Sensitivity"
  if(par>1) ylab<- NULL
  
  # Create the plot
  ggplot(df, aes(x = Method, y = TotSens, color=Method)) +
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
          legend.position="none",
          axis.text.x = element_text(angle = 45, hjust = 1))
}

#times 10min to 10h
# Create plots
G_plots <- list(
  create_plot(1,"G"),
  create_plot(2,"G"),
  create_plot(3,"G"),
  create_plot(4,"G"),
  create_plot(5,"G")
)

Hymod_plots <- list(
  create_plot(1,"Hymod"),
  create_plot(2,"Hymod"),
  create_plot(3,"Hymod"),
  create_plot(4,"Hymod"),
  create_plot(5,"Hymod")
)


# Arrange plots with labels
g <- grid.arrange(
  # Top row (G function)
  textGrob("G function", rot = 90, gp = gpar(fontsize = 22)),
  arrangeGrob(grobs = G_plots[1:5], ncol = 5),
  
  # Bottom row (Hymod)
  textGrob("Hymod", rot = 90, gp = gpar(fontsize = 22)),
  arrangeGrob(grobs = Hymod_plots[1:5], ncol = 5),
  
  ncol = 2,  # Two columns: labels and plots
  widths = c(1, 20)  # Adjust width ratio of label column to plot column
)

# Display the plot
filename<- "New_Figures/plotMatrix_Hymod_vs_G_TS.jpeg"
jpeg(file = filename,width = 1200,height=600,type="cairo")
grid.draw(g)
dev.off()