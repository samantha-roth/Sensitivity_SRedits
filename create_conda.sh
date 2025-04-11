#!/bin/bash
#SBATCH --job-name=create_env
#SBATCH --output=create_env.%j.out
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=5gb

echo "Job starting on `hostname` at `date`"

cd /dartfs-hpc/rc/home/t/f0071xy

conda env create --file jeremy_env.yml

conda deactivate

echo "Job ending on `hostname` at `date`"