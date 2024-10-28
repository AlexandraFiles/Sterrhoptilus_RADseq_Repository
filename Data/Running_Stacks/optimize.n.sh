#!/bin/sh
#
#SBATCH --job-name=optimize.n                           #Job Name
#SBATCH --nodes=1                                       #Request number of nodes
#SBATCH --cpus-per-task=15                              #CPU allocation per Task
#SBATCH --partition=bi                                  #Name of the Slurm partition used
#SBATCH --chdir=/home/a619f280/work/phil.stachyris    	  #Set working directory
#SBATCH --mem-per-cpu=1gb                               #Memory requested
#SBATCH --time=5000                                    #Time requested

files="S_capitalis_28326
S_capitalis_28338
S_capitalis_28339
S_capitalis_28341
S_capitalis_28342
S_capitalis_29959
S_capitalis_29965
S_capitalis_29968
S_capitalis_CMNH37769
S_dennistouni_19648
S_dennistouni_19656
S_dennistouni_20186
S_dennistouni_20187
S_dennistouni_20188
S_dennistouni_20191
S_dennistouni_20201
S_dennistouni_20222
S_dennistouni_20224
S_dennistouni_20225
S_dennistouni_20229
S_dennistouni_20335
S_dennistouni_21084
S_dennistouni_21112
S_dennistouni_25696
S_dennistouni_25702
S_dennistouni_25703
S_dennistouni_25716
S_dennistouni_25743
S_dennistouni_25817
S_dennistouni_25828
S_dennistouni_25846
S_dennistouni_25885
S_dennistouni_25898
S_dennistouni_25903
S_dennistouni_25908
S_dennistouni_25939
S_dennistouni_26573
S_dennistouni_26579
S_dennistouni_26961
S_nigrocapitata_14192
S_nigrocapitata_14199
S_nigrocapitata_18034
S_nigrocapitata_18040
S_nigrocapitata_18083
S_nigrocapitata_25550
S_nigrocapitata_33030
S_nigrocapitata_33060
S_plateni_19056
S_plateni_28305
S_plateni_28350"

# Build loci de novo in each sample for the single-end reads only.
# -M — Maximum distance (in nucleotides) allowed between stacks (default 2).
# -m — Minimum depth of coverage required to create a stack (default 3).
#here, we will vary m from 3-7, and leave all other paramaters default

for i in {1..8}
do
#create a directory to hold this unique iteration:
mkdir stacks_n$i
#run ustacks with m equal to the optimized value, and 
id=1
for sample in $files
do
    /home/d669d153/work/stacks-2.41/ustacks -f fastq/${sample}.fq.gz -o stacks_n$i -i $id -m 4 -M 3 -p 15
    let "id+=1"
done
## Run cstacks to compile stacks between samples. Popmap is a file in working directory called 'pipeline_popmap.txt'
/home/d669d153/work/stacks-2.41/cstacks -n $i -P stacks_n$i -M pipeline_popmap.txt -p 15
## Run sstacks. Match all samples supplied in the population map against the catalog.
/home/d669d153/work/stacks-2.41/sstacks -P stacks_n$i -M pipeline_popmap.txt -p 15
## Run tsv2bam to transpose the data so it is stored by locus, instead of by sample.
/home/d669d153/work/stacks-2.41/tsv2bam -P stacks_n$i -M pipeline_popmap.txt -t 15
## Run gstacks: build a paired-end contig from the metapopulation data (if paired-reads provided),
## align reads per sample, call variant sites in the population, genotypes in each individual.
/home/d669d153/work/stacks-2.41/gstacks -P stacks_n$i -M pipeline_popmap.txt -t 15
## Run populations completely unfiltered and output unfiltered vcf, for input to the RADstackshelpR package
/home/d669d153/work/stacks-2.41/populations -P stacks_n$i -M pipeline_popmap.txt --vcf -t 15
done