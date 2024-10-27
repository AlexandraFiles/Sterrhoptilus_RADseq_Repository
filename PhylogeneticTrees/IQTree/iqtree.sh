#!/bin/sh
#
#SBATCH --job-name=iqtree               # Job Name
#SBATCH --nodes=1             # nodes requested
#SBATCH --ntasks-per-node=15               # CPUs requested
#SBATCH --partition=sixhour         # Name of the Slurm partition used
#SBATCH --chdir=/home/a619f280/work/phil.stachyris/IQTree  # Set working d$
#SBATCH --mem-per-cpu=2gb            # memory requested
#SBATCH --time=360

#-s specifies the input sequence data
#-m MFP specifies to perform model testing and use the best model of sequence evolution
#-bb specifies performing 1000 ultrafast bootstraps to assess support
#-nt AUTO allows the program to use the optimal number of threads (15 specified here)
/home/d669d153/work/iqtree-2.2.0-Linux/bin/iqtree2 -s pops.phy -m MFP -bb 1000 -nt AUTO
