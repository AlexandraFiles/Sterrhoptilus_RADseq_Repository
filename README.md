*Sterrhoptilus* RADSeq Analyses
================
Alexandra Files

### Data and Sampling

All data needed to replicate the analyses, as well as detailed code for
how SNPs were filtered can be found in the [data folder](./Data). This
folder details the process that I followed to run *Stacks* on the raw
Illumina sequenced reads to demultiplex the data then perform *de novo*
reference assembly. I then used [Devon DeRaad’s
SNPfiltR](https://github.com/DevonDeRaad/SNPfiltR) R package to filter
SNPs.

A sampling map can be found in the folder [SamplingMap](./SamplingMap)
to visualize the sampling of the dataset.

### Phylogenetic Tree Reconstructions

I used the filtered datasets to reconstruct *Sterrhoptilus* phylogenetic
relationships and looked at a rooted tree with *IQTree*, an unrooted
phylogenetic network with *SplitsTree*, and a species tree using
*SNAPP*. The results and necessary data can be found in the folder
[PhylogeneticTrees](./PhylogeneticTrees)

### PCA and Fst

I made a PCA plot with the code found in the folder
[PCA](./PopulationStructure/PCA).

For looking at Fst values, I split *S. dennistouni* into northern birds
(sampled north of the putative hybrid zone) and southern individuals
(those sampled from within the putative hybrid zone). Code for
calculating Fst values and fixed differences is in the folder
[Fst](./PopulationStructure/Fst).

### *ADMIXTURE*

I ran *ADMIXTURE* several times on this dataset, subsetting the data and
including or excluding singletons. In the folder
[Admixture](./Admixture), I have detailed the results of these runs and
compared the resulting plots.

### Hybridization

I first tested for hybridization in *Sterrhoptilus* by looking at
Patterson’s D statistic (ABBA/BABA tests) and found that *S.
nigrocapitatus* and *S. affinis* had a non-significant D statistic, but
*S. affinis* and *S. dennistouni* did share an excess of alleles than
would be expected from incomplete lineage sorting alone. Those results
can be found in the [Dsuite](./Dsuite) folder.

I then looked at heterozygosity and hybrid index, to determine what
generation of hybrids were sampled. I performed two similar runs, both
within the [TrianglePlot](./TrianglePlot) folder, were I chose different
*S. dennistouni* to be one parental population.

### Mitochondrial Data

I downloaded the sequenced mitochondrial data from [Hosner et
al. 2018](https://doi.org/10.1007/s10592-018-1085-4) and constructed a
phylogenetic tree and mitochondrial haplotype network. Exact
specifications for both visualizations can be found in the
[MitochondrialData](./MitochondrialData) folder.
