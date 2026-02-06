The R packages in the format "`package` (version)" required for this analysis arerequired for this analysis are `sensobol` (1.1.5), `lhs` (1.2.0), `BASS` (1.3.1), `GPfit` (1.0-8), and `mcmcse` (1.5-0). 

Before installing the necessary R packages, we recommend updating R to version 4.4.2 and deleting any dependences for any of these R packages that were installed on an earlier version of R. This workflow has been tested using The Pennsylvania State University's ROAR high-performance computing system.

This analysis contains four options of computer models: Sobol's G function, a simple polynomial function, Hymod, and SAC-SMA. This analysis also contains six options of numbers of model parameters (2, 5, 10, 15, 20, 30) for the G function and the polynomial. When the number of parameters is 15 or more, obtaining sensitivity analysis results for the G function may take a very long time. We recommend using a high-performance computing system to run these codes.

## Description of scripts

1. `0_library.R` (`0_libraryHymod.R`, `0_librarySACSMA10par`, `polynomial/0_libraryPoly.R`) is the script that loads all the packages and defines the test models and the numbers of parameters to test. Edit this script to define the working directory. This script is called by the other scripts that perform sensitivity analysis and does not have to be run on its own. `0_library.R` corresponds to Sobol's G function, `0_libraryHymod.R` corresponds to Hymod,`0_librarySACSMA10par.R` corresponds to SACSMA, and `0_libraryPoly.R` in the `polynomial` folder corresponds to the polynomial function.

2. Scripts starting with 1_ to 4_ perform Sobol' sensitivity sensitivity analysis. They record the first, second, and total order sensitivity indices for all parameters. They also record the parameter rankings and the number of samples from the model (or emulator) needed for the rankings to converge. For the emulation-based approaches, which start with a 2, 3, or 4, they also record the amount of training data needed to fit the emulator. Finally, they record the amount of compute time needed for each step in the process.

3. Scripts starting with 5_ compute quantities to compare the sensitivity analysis approaches based on their outputs. Run scripts starting with the following in the following order:
    * `5_computeTotalTimes` then
    * `5_computeTimeStats`.
      
   After that, you can run scripts starting with `5_getMeanBestAcrossSeeds`, and after running all of those, you can run `5_getMeanBestAllModels.R` and `5_getMeanWorstAllModels.R`. You do not need to wait until after running scripts that start with `5_computeTotalTimes` to run scripts starting with `5_getRankings`. After running the scripts startings with `5_getRankings`, you can run the scripts starting with `5_getRho`. Scripts that start with `5_getRho` and end with `0.05` such as 5_getRho_SACSMA10_0.05.R` remove parameters with total sensitivity indices less than 0.05 from the calculations to consider how removing the effects of unimportant parameters changes results. We find results are practically the same.

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
