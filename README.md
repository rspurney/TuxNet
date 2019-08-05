# TuxNet
Matlab App to process raw RNA-seq data and infer GRNs from the processed data. Published and maintained by Sozzani Lab at North Carolina State University.

Visit https://rspurney.github.io/TuxNet/ for tutorials on remotely accessing and running TuxNet.

## Installation
xxx

## TUX
The TUX tab processes raw RNAseq data using fastq-mcf and a modified Tuxedo pipeline (HISAT2 + Cufflinks package) to extract a wide array of information including measures of differential expression. This output can then be used by TuxOP to tabulate FPKM values, average gene expression, and differentially expressed genes (DEGs) between states of an experiment.

## GENIST
The GENIST tab implements a Dynamic Bayesian network (DBN)-based inference algorithm that uses time-course data to infer GRNs for a list of genes. The output of TUX can be directly imported into GENIST to predict causal relations and the output of GENIST can be imported into programs like Cytoscape for visualization.

## RTP-STAR
The RTP-STAR tab implements a regression tree algorithm (GENIE3) and uses biological replicates of steady state gene expression data to infer GRNs for a listo of genes. The output of TUX can be directly imported into RTP-STAR to predict causal relations and the output of RTP-STAR can be imported into programs like Cytoscape for visualization.

More details on running the software are provided in the following manuscript:
**TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks**

## Contact Info

Please contact Ryan Spurney at <rjspurne@ncsu.edu> or Dr. Ross Sozzani at <ross_sozzani@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
