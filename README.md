The R packages required for this analysis are `sensobol`, `lhs`, `BASS`, `GPfit`, and `mcse`. 

Before installing the necessary R packages, we recommend updating R to version 4.4.2 and deleting any dependences for any of these R packages that were installed on an earlier version of R.

To run the analysis, simply follow the scripts based on their beginning numbers:

0_library.R is the script that loads all the packages, functions and parameters. You may change the test function to use or the testing dimensions or the sample sizes in this script. (you also define the working directory here, essentially you only to make changes in this script)

1_ through 4_ scripts are the analysis of the four sensitivity analysis methods. They record the convergence size and sensitivity indices under different sample sizes.

5_ scripts compute quantities for comparison of sensitivity analysis approaches based on their outputs. Run these in the following order, where only 1 and 2 are needed to generate FastestMeanTime.pdf.
1. Scripts starting with 5_computeTotalTimes
2. Scripts starting with 5_computeTimeStats
3. Scripts starting with 5_getBestForAllSeeds

6_ scripts compare sensitivity analysis approaches using the computed quantities.
- Scripts starting with 6_howBetterIsBest should be run before those starting with 6_whatIsBetterNoBest.
- To generate FastestMeanTime.pdf, run 6_bestFor30D.R

7_ scripts generate plots to compare sensitivity analysis approaches.
- To generate FastestMeanTime.pdf, run 7_FastestMeanTimeFig.R

10_Timescales.R generates plots that show the timescale needed for each combination of model run time and model input dimension. There is one plot per sensitivity analysis method.

checking_SA_outputs.R provides checks to make sure sensitivity analysis outputs have appropriate dimensions and values.

decomposeTotalTimes.R analyzes what steps of sensitivity analysis take longest and shortest for each method and how the time needed for different steps varies between methods.

Hymod.R and sacSma.R are the two hydro models. arnosubbiano.rda and SacSma_dataframe are the corresponding data required to run the two hydro models. sobol_indices_boot.R is a function that allows bootstrapping using sensobol package.

The folder Ranking_Data includes all the required data. You may compare your running results with these data, but notice that the recorded sample sizes, running time and sensitivity indices won't be the same because of random seeds and different computational environments. However you should get similar figures (compare with the figures in New_Figures folder).

**Note that 2_, 3_ and 4_ scripts take a very long time to run when k= 5 or 6, you may begin with low-dimensional test functions to make sure the script can run successfully.
