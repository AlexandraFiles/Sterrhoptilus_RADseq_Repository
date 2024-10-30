Phylogenetic Trees for *Sterrhoptilus*
================
Alexandra Files

This folder contains all files and results from running *IQTree* to make
a phylogenetic tree and the unrooted phylogenetic network using
*SplitsTree*.

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
