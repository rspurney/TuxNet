# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Local Installation

The local use of TuxNet requires a 64-bit computer running Mac or Linux with MATLAB installed **(R2017b or later ONLY)**.

To run TuxNet, download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then, run the TuxNet.mlapp file.

The MATLAB [Bioinformatics Toolbox](https://www.mathworks.com/products/bioinfo.html) and [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) are both required to run GENIST and RTP-STAR.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml) must be installed before the TUX tab can be run using TuxNet. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make'. **Once this is done, you must copy the HISAT2 folder into the TuxNet-HISAT2 folder and change the HISAT2 folder name to 'hisat2'. Otherwise, TuxNet will not be able to find the HISAT2 files.**

[Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/) must be installed before the TUX tab can be run using TuxNet. To install Cufflinks, download the correct binary and unzip the file. **Once this is done, you must copy the Cufflinks folder into the TuxNet-HISAT2 folder and change the Cufflinks folder name to 'cufflinks'. Otherwise, TuxNet will not be able to find the Cufflinks files.**

[ea-utils](https://expressionanalysis.github.io/ea-utils/) must be installed before the TUX tab can be run using TuxNet. To install ea-utils, download and unzip the file and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make install'. **Once this is done, you must copy the ea-utils folder into the TuxNet-HISAT2 folder and change the ea-utils folder name to 'ea-utils'. Otherwise, TuxNet will not be able to find the ea-utils files.**

[SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet. To install SAMtools, download and unzip the file and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make install'. **Once this is done, you must copy the SAMtools folder into the TuxNet-HISAT2 folder and change the SAMtools folder name to 'samtools'. Otherwise, TuxNet will not be able to find the SAMtools files.**

## TUX
The TUX tab <span style="color:blue">processes raw RNAseq data</span> using fastq-mcf and a modified Tuxedo pipeline (HISAT2 + Cufflinks package) to extract a wide array of information including measures of differential expression. This output can then be used by TuxOP to tabulate FPKM values, average gene expression, and differentially expressed genes (DEGs) between states of an experiment.

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
