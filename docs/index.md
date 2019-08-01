# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Table of Contents
* [Local Installation](#local-installation)
  * [Mac and Linux](#mac-and-linux)
    * [MATLAB Version](#matlab-version)
    * [Standalone Version](#standalone-version)
    * [Required Software](#required-software)
  * [Windows](#windows)
* [TUX](#tux)
* [GENIST](#genist)
* [RTP-STAR](#rtp-star)
* [Additional Info](#additional-info)

## Local Installation

### Mac and Linux

#### MATLAB Version
The use of the MATLAB version of TuxNet requires a 64-bit computer running Mac or Linux with MATLAB installed **(R2017b or later ONLY)**.

#### Standalone Version
The use of the Mac / Linux Standalone version of TuxNet requires a 64-bit computer running Mac or Linux.

#### Required Software
To run the Mac / Linux MATLAB or Standalone version of TuxNet, download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then, run the TuxNet.mlapp file.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml), [Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/), [ea-utils](https://expressionanalysis.github.io/ea-utils/), and [SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet. <span style="color:#39c">Once these are downloaded and installed, you must copy the folders into the folder where TuxNet is located and change the folder names to 'hisat2', ' cufflinks', 'ea-utils', and 'samtools', respectively. Otherwise, TuxNet will not be able to find the needed files.</span>

The MATLAB [Bioinformatics Toolbox](https://www.mathworks.com/products/bioinfo.html) and [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) are both required to run GENIST and RTP-STAR on the MATLAB version of TuxNet.

### Windows
stuff about windows version

## TUX
The TUX tab <span style="color:#39c">processes raw RNAseq data</span> using fastq-mcf and a modified Tuxedo pipeline (HISAT2 + Cufflinks package) to extract a wide array of information including measures of differential expression. This output can then be used by TuxOP to tabulate FPKM values, average gene expression, and differentially expressed genes (DEGs) between states of an experiment.

## GENIST
The GENIST tab implements a <span style="color:#39c">Dynamic Bayesian network (DBN)-based inference algorithm</span> that uses <span style="color:#39c">time-course data to infer GRNs</span> for a list of genes. The output of TUX can be directly imported into GENIST to <span style="color:#39c">predict causal relations</span> and the output of GENIST can be imported into programs like Cytoscape for visualization.

## RTP-STAR
The RTP-STAR tab implements a <span style="color:#39c">regression tree algorithm</span> (GENIE3) and uses <span style="color:#39c">biological replicates of steady state gene expression data to infer GRNs</span> for a list of genes. The output of TUX can be directly imported into RTP-STAR to <span style="color:#39c">predict causal relations</span> and the output of RTP-STAR can be imported into programs like Cytoscape for visualization.

## Additional Info

More details on running the software are provided in the following manuscript:
*TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks*

Please contact Ryan Spurney at <rjspurne@ncsu.edu> or Dr. Ross Sozzani at <ross_sozzani@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
