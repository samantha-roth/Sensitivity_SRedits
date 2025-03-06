To run the analysis, simply follow the scripts based on their beginning numbers:

0_library.R is the script that loads all the packages, functions and parameters. You may change the test function to use or the testing dimensions or the sample sizes in this script. (you also define the working directory here, essentially you only to make changes in this script)

1_ through 4_ scripts are the analysis of the four sensitivity analysis methods. They record the convergence size and sensitivity indices under different sample sizes.

10_Timescales.R generates plots that show the timescale needed for each combination of model run time and model input dimension. There is one plot per sensitivity analysis method.

11_CompareTotalTimes.R generates plots that tell you for each combination of model run time and model input dimension: (1) which method is the fastest, (2) how long the fastest method takes, (3) the difference in timescales between each method and the fastest method, and (4) the difference in timescales between each method.

checking_SA_outputs.R provides checks to make sure sensitivity analysis outputs have appropriate dimensions and values.

decomposeTotalTimes.R analyzes what steps of sensitivity analysis take longest and shortest for each method and how the time needed for different steps varies between methods.

Hymod.R and sacSma.R are the two hydro models. arnosubbiano.rda and SacSma_dataframe are the corresponding data required to run the two hydro models. sobol_indices_boot.R is a function that allows bootstrapping using sensobol package.

The folder Ranking_Data includes all the required data. You may compare your running results with these data, but notice that the recorded sample sizes, running time and sensitivity indices won't be the same because of random seeds and different computational environments. However you should get similar figures (compare with the figures in New_Figures folder).

**Note that 2_, 3_ and 4_ scripts take a very long time to run, you may begin with low-dimensional test functions to make sure the script can run successfully.
