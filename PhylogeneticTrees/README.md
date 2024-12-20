Phylogenetic Trees for *Sterrhoptilus*
================
Alexandra Files

This folder contains all files and results from running *IQTree* to make
a phylogenetic tree, an unrooted phylogenetic network using
*SplitsTree*, and a species tree using *SNAPP*.

### IQTree

The folder [IQTree](IQTree) contains the bash script for running
*IQTree* and all the subsequent results. I generated
[pops.phy](./IQTree/pops.phy) file for input into *IQTree* with
*Stack’s* population model with [whitelist.txt](./IQTree/whitelist.txt)
(containing all locus names) and
[iqtree.popmap.txt](./IQTree/iqtree.popmap.txt) (containing all samples)
files. I performed 1000 ultra-fast bootstrap replicates and had IQTree
select the best AIC tree.

I visualized [pops.phy.treefile](IQTree/pops.phy.treefile) with
*FigTree*, rooted on the outgroup *D. plateni*.

<figure>
<img src="Sterrhoptilus_PhylogeneticTree.svg"
alt="Phylogenetic Tree Rooted on D. plateni visualized with FigTree" />
<figcaption aria-hidden="true">Phylogenetic Tree Rooted on <em>D.
plateni</em> visualized with <em>FigTree</em></figcaption>
</figure>

### SplitsTree

I prepared the vcf file for *SplitsTree* by editing sample names and
making a pairwise divergence matrix using the script
[Sterrhoptilus_PreparationforSplitsTree](Sterrhoptilus_PreparationforSplitsTree.R),
generating the [input text file](splitstree.nooutgroup.txt) for
visualization in *SplitsTree*.

<figure>
<img src="Sterrhoptilus_PhylogeneticNetwork.svg"
alt="Unrooted Phylogenetic Network Visualized with SplitsTree" />
<figcaption aria-hidden="true">Unrooted Phylogenetic Network Visualized
with <em>SplitsTree</em></figcaption>
</figure>

### SNAPP

I randomly subsampled my data to have three individuals from each
species (putative hybrids were not eligible to be selected for
subsampling) five separate times, using the [Preparation for Snapp
script](./SNAPP/Sterrhoptilus_PreparationforSnappTree.R). This resulted
in five nexus files, with random subsampling of the data that can be
found in the [SNAPP folder](./SNAPP). For each nexus file, I used
*BEAUti* to make .xml files for input into *BEAST*, specifying … model
specifications. All nexus files, xml files, and output trees can be
found in the [SNAPP folder](./SNAPP).

All species trees converged on the same topology, tree from
[1.nex](./SNAPP/1.nex) is shown below.
