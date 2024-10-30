#!/bin/sh
#
#SBATCH --job-name=admixture               # Job Name
#SBATCH --nodes=1             # 40 nodes
#SBATCH --ntasks-per-node=10               # 40 CPU allocation per Task
#SBATCH --partition=sixhour         # Name of the Slurm partition used
#SBATCH --chdir=/home/a619f280/work/phil.stachyris/rerunofeverything/admixonlydenandaffnosingletons    # Set working d$
#SBATCH --mem-per-cpu=1gb            # memory requested
#SBATCH --time=360

#use plink to convert vcf directly to bed format:
/home/d669d153/work/plink --vcf sterrhoptilusadmix_onlydenandaff.mac.vcf.gz --double-id --allow-extra-chr --make-bed --out binary_fileset
#fix chromosome names
cut -f2- binary_fileset.bim  > temp
awk 'BEGIN{FS=OFS="\t"}{print value 1 OFS $0}' temp > binary_fileset.bim

#run admixture for a K of 1-10, using cross-validation, with 10 threads
for K in 1 2 3 4 5 6 7 8 9 10; 
do /home/d669d153/work/admixture_linux-1.3.0/admixture --cv -j10 binary_fileset.bed $K | tee log${K}.out;
done

#Which K iteration is optimal according to ADMIXTURE ?
grep -h CV log*.out > log.errors.txt
