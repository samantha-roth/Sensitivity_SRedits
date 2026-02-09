#!/bin/bash
#
#SBATCH --job-name=FILENAME
#SBATCH --output=FILENAME_output.%j.out
#SBATCH --nodes=N_NODES
#SBATCH --ntasks-per-node=N_TASKS
#SBATCH --mem=MEMGB
#SBATCH --time=HOURS:00:00
#SBATCH --account=ACCOUNT
#SBATCH --partition=PARTITION
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_90
#SBATCH --mail-user=EMAIL

echo "Job started on `hostname` at `date`"

module load r
cd FOLDER_LOCATION/Sensitivity_SRedits
Rscript FILENAME.R

echo "Job Ended at `date`"