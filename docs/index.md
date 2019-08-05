# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Table of Contents
* [Local Installation](#local-installation)
  * [Mac and Linux](#mac-and-linux)
    * [MATLAB Version](#matlab-version)
    * [Standalone Versions](#standalone-versions)
    * [Required Software and Installation](#required-software-and-installation)
  * [Windows](#windows)
    * [Installation](#installation)
* [TUX](#tux)
* [GENIST](#genist)
* [RTP-STAR](#rtp-star)
* [Additional Info](#additional-info)

## Local Installation

### Mac and Linux

#### MATLAB Version
The use of the MATLAB version of TuxNet requires a 64-bit computer running Mac or Linux with MATLAB installed **(R2017b or later ONLY)**.

#### Standalone Versions
The use of the Mac or Linux Standalone versions of TuxNet requires a 64-bit computer but does not require a MATLAB installation.

#### Required Software and Installation
Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet using Arabidopsis data, unzip genome.fa.zip (included in the folder).

To use the MATLAB version of TuxNet, run TuxNet.mlapp.

To use the Mac Standalone version of TuxNet, run 'TuxNet-MacStandaloneInstaller.app' in the TuxNet-MacStandalone directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. To run TuxNet, run 'TuxNet.app' in the 'application' folder, located in the folder you chose for TuxNet to be installed in. You will be prompted to choose the current working directory via a file finder: '&lt;TuxNetLocation&gt;/application' should be your selection.
 
 To use the Linux Standalone version of TuxNet, execute 'sudo ./TuxNet-LinuxStandaloneInstaller.install' in the TuxNet-LinuxStandalone directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. To run TuxNet, execute 'sudo ./run_TuxNet.sh <mcr_directory>' where <mcr_directory> in the location where MATLAB Runtime is installed. For example: ‘sudo ./run_TuxNet.sh /home/user/username/MATLAB_Runtime/v96’. You will be prompted to choose the current working directory via a file finder: '&lt;TuxNetLocation&gt;/application' should be your selection.
 
[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml), [Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/), [ea-utils](https://expressionanalysis.github.io/ea-utils/), and [SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet. **Once these are downloaded and installed, you must copy the folders into the folder where TuxNet is located and change the folder names to 'hisat2', ' cufflinks', 'ea-utils', and 'samtools', respectively. Otherwise, TuxNet will not be able to find the needed files.**

### Windows

#### Installation
Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder.

To install, run 'TuxNet-WindowsStandaloneInstaller.exe' in the TuxNet-WindowsStandalone directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. Note that the Windows Standalone version of TuxNet cannot run the modified Tuxedo pipeline. To run TuxNet, run 'TuxNet.exe' in the 'application' folder, located in the folder you chose for TuxNet to be installed in. You will be prompted to choose the current working directory via a file finder: '&lt;TuxNetLocation&gt;/application' should be your selection.
 
## TUX
The TUX tab **processes raw RNAseq data** using fastq-mcf and a modified Tuxedo pipeline (HISAT2 + Cufflinks package) to extract a wide array of information including measures of differential expression. This output can then be used by TuxOP to tabulate FPKM values, average gene expression, and differentially expressed genes (DEGs) between states of an experiment.

## GENIST
The GENIST tab implements a **Dynamic Bayesian network (DBN)-based inference algorithm** that uses **time-course data to infer GRNs** for a list of genes. The output of TUX can be directly imported into GENIST to **predict causal relations** and the output of GENIST can be imported into programs like Cytoscape for visualization.

## RTP-STAR
The RTP-STAR tab implements a **regression tree algorithm** (GENIE3) and uses **biological replicates of steady state gene expression data to infer GRNs** for a list of genes. The output of TUX can be directly imported into RTP-STAR to **predict causal relations** and the output of RTP-STAR can be imported into programs like Cytoscape for visualization.

## Additional Info

More details on running the software are provided in the following manuscript:
*TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks*

Please contact Ryan Spurney at <rjspurne@ncsu.edu> or Dr. Ross Sozzani at <ross_sozzani@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
