#!/bin/sh
#
#SBATCH --job-name=treemix              # Job Name
#SBATCH --nodes=1             # 40 nodes
#SBATCH --ntasks-per-node=1               # 40 CPU allocation per Task
#SBATCH --partition=sixhour            # Name of the Slurm partition used
#SBATCH --chdir=/home/a619f280/work/phil.stachyris/treemix     # Set working d$
#SBATCH --mem-per-cpu=5gb           # memory requested
#SBATCH --time=100

#convert vcf into treemix file
/home/a619f280/work/programs/stacks-2.68/populations --in-vcf Sterrhoptilus_thinned_nooutgroup.vcf.gz -O . --treemix -M treemix_popmap_nooutgroup.txt
#remove stacks header
echo "$(tail -n +2 Sterrhoptilus_thinned_nooutgroup.p.treemix)" > Sterrhoptilus_thinned_nooutgroup.p.treemix
#gzip file for input to treemix
gzip Sterrhoptilus_thinned_nooutgroup.p.treemix

#run treemix with m0
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i Sterrhoptilus_thinned_nooutgroup.p.treemix.gz -o ./treemix_results/Sterrhoptilus_treemix.1.0 -root capitalis

for m in {1..3}; do
    for i in {1..5}; do
        # Generate random seed
        s=$RANDOM
        /panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i Sterrhoptilus_thinned_nooutgroup.p.treemix.gz -o ./treemix_results/Sterrhoptilus_treemix.${i}.${m} -m ${m} -seed ${s} -root capitalis
    done
done
