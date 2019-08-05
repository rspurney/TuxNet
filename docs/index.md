# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Table of Contents
* [Local Installation](#local-installation)
  * [MATLAB Version](#matlab-version)
  * [Mac Standalone Version](#mac-standalone-version)
  * [Linux Standalone Version](#linux-standalone-version)
  * [Windows Standlone Version](#windows-standalone-version)
  * [Required Software](#required-software)
  * [Video Tutorial](#video-tutorial)
* [TUX](#tux)
* [GENIST](#genist)
* [RTP-STAR](#rtp-star)
* [Additional Info](#additional-info)

## Local Installation

### MATLAB Version
The use of the MATLAB version of TuxNet requires a 64-bit computer running Mac or Linux with MATLAB installed **(R2017b or later)**.

Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To use the MATLAB version of TuxNet, run `TuxNet.mlapp`.

### Mac Standalone Version
The use of the Mac Standalone version of TuxNet requires a 64-bit computer but **does not require a MATLAB installation**.

Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To install the Mac Standalone version of TuxNet, run `TuxNet-MacStandaloneInstaller.app` in the `TuxNet-MacStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. 

To run TuxNet, run `TuxNet.app` in the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the folder you chose to install TuxNet. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.
 
### Linux Standalone Version
The use of the Linux Standalone version of TuxNet requires a 64-bit computer but **does not require a MATLAB installation**.

Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To install the Linux Standalone version of TuxNet, execute `sudo ./TuxNet-LinuxStandaloneInstaller.install` in the `TuxNet-LinuxStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. 

To run TuxNet, navigate to the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the folder you chose to install TuxNet and execute `sudo ./run_TuxNet.sh <mcr_directory>` where `<mcr_directory>` is the location where MATLAB Runtime is installed. For example: `sudo ./run_TuxNet.sh /home/user/username/MATLAB_Runtime/v96`. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.

### Windows

Download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder.

To install, run `TuxNet-WindowsStandaloneInstaller.exe` in the `TuxNet-WindowsStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. Note that the Windows Standalone version of TuxNet cannot run the modified Tuxedo pipeline. 

To run TuxNet, run `TuxNet.exe` in the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the folder you chose to install TuxNet. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.

### Required Software
[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml), [Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/), [ea-utils](https://expressionanalysis.github.io/ea-utils/), and [SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet on the MATLAB, Mac Standalone, and Linux Standalone versions. **Once these are downloaded and installed, you must copy the folders into the folder where TuxNet is located and change the folder names to `hisat2`, `cufflinks`, `ea-utils`, and `samtools`, respectively. Otherwise, TuxNet will not be able to find the needed files.**

### Video Tutorial
Follow this tutorial to learn how to install and run the MATLAB and Standalone versions of TuxNet for Mac. The steps to install the Linux and Windows versions are similar and require only slight modification, detailed above.

video
 
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
