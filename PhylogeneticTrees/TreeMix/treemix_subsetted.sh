#!/bin/sh
#
#SBATCH --job-name=treemix              # Job Name
#SBATCH --nodes=1             # 40 nodes
#SBATCH --ntasks-per-node=1               # 40 CPU allocation per Task
#SBATCH --partition=sixhour            # Name of the Slurm partition used
#SBATCH --chdir=/home/a619f280/work/phil.stachyris/treemix     # Set working d$
#SBATCH --mem-per-cpu=5gb           # memory requested
#SBATCH --time=100

for i in {1..5}; do
	#convert vcf into treemix file
	/home/a619f280/work/programs/stacks-2.68/populations --in-vcf Sterrhoptilus_thinned_nooutgroup${i}.vcf.gz -O . --treemix -M treemix_popmap_nooutgroup.txt
	#remove stacks header
	echo "$(tail -n +2 Sterrhoptilus_thinned_nooutgroup${i}.p.treemix)" > Sterrhoptilus_subsetted.${i}.p.treemix
	#gzip file for input to treemix
	gzip Sterrhoptilus_subsetted.${i}.p.treemix
	for m in {1..3}; do
    	# Generate random seed
    	s=$RANDOM
    	/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i Sterrhoptilus_subsetted.${i}.p.treemix.gz -o ./treemix_results_subsetted/Sterrhoptilus_treemix.${i}.${m} -m ${m} -seed ${s} -root capitalis
	done
done
