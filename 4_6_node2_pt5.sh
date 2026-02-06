#!/bin/bash
#
#SBATCH --job-name=4_6_node2_pt5
#SBATCH --output=4_6_node2_pt5_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20GB
#SBATCH --time=144:00:00
#SBATCH --account=pches_cr_default
#SBATCH --partition=himem
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu  

echo "Job starting on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision
Rscript 4_AKMCS6_node2_pt5.R

echo "Job ending on `hostname` at `date`"