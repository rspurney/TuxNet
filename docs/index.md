# TuxNet
MATLAB app to process raw RNA sequencing data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Table of Contents
* [Local Installation](#local-installation)
  * [MATLAB Version](#matlab-version)
  * [Mac Standalone Version](#mac-standalone-version)
  * [Linux Standalone Version](#linux-standalone-version)
  * [Windows Standalone Version](#windows-standalone-version)
  * [Required Software](#required-software)
  * [Video Tutorial](#video-tutorial)
* [TUX](#tux)
* [GENIST](#genist)
* [RTP-STAR](#rtp-star)
* [Additional Info](#additional-info)

## Local Installation

### MATLAB Version
The use of the MATLAB version of TuxNet requires a 64-bit computer running Mac or Linux **with MATLAB installed (R2017b or later)**.

Download the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To use the MATLAB version of TuxNet, run `TuxNet.mlapp` ub the `TuxNet-MATLAB` directory.

### Mac Standalone Version
The use of the Mac Standalone version of TuxNet requires a 64-bit computer but **does not require a MATLAB installation**.

Download the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To install, run `TuxNet-MacStandaloneInstaller.app` in the `TuxNet-MacStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. 

To use TuxNet, run `TuxNet.app` in the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the directory where you chose to install TuxNet. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.
 
### Linux Standalone Version
The use of the Linux Standalone version of TuxNet requires a 64-bit computer but **does not require a MATLAB installation**.

Download the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip. To run TuxNet using Arabidopsis data, unzip `genome.fa.zip`.

To install, execute `sudo ./TuxNet-LinuxStandaloneInstaller.install` in the `TuxNet-LinuxStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. 

To use TuxNet, navigate to the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the directory where you chose to install TuxNet and execute `sudo ./run_TuxNet.sh <mcr_directory>` where `<mcr_directory>` is the location where MATLAB Runtime is installed. For example: `sudo ./run_TuxNet.sh /home/user/username/MATLAB_Runtime/v96`. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.

### Windows Standalone Version

Download the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip.

To install, run `TuxNet-WindowsStandaloneInstaller.exe` in the `TuxNet-WindowsStandalone` directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed. Note that the Windows Standalone version of TuxNet cannot run the modified Tuxedo pipeline. 

To use TuxNet, run `TuxNet.exe` in the `<TuxNetLocation>/application` directory where `<TuxNetLocation>` is the directory where you chose to install TuxNet. You will be prompted to choose the current working directory via a file finder: `<TuxNetLocation>/application` should be your selection.

### Required Software
[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml), [Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/), [ea-utils](https://expressionanalysis.github.io/ea-utils/), and [SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet on the MATLAB, Mac Standalone, and Linux Standalone versions. **Once these are downloaded and installed, you must copy the folders into the directory where TuxNet is located and change the folder names to `hisat2`, `cufflinks`, `ea-utils`, and `samtools`, respectively. Otherwise, TuxNet will not be able to find the needed files.**

### Video Tutorial
Follow this tutorial to learn how to install and run the MATLAB and Standalone versions of TuxNet for Mac. The steps to install the Linux and Windows versions are similar and require only slight modification, detailed above.

<iframe width="560" height="315" src="https://www.youtube.com/embed/twsYTAxroF8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
 
## TUX
The TUX tab **processes raw RNAseq data** using fastq-mcf and a modified Tuxedo pipeline (HISAT2 + Cufflinks package) to extract a wide array of information including measures of differential expression. This output can then be used by TuxOP to tabulate FPKM values, average gene expression, and differentially expressed genes (DEGs) between states of an experiment.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Qao-CVzts1M" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## GENIST
The GENIST tab implements a **Dynamic Bayesian network (DBN)-based inference algorithm** that uses **time-course data to infer GRNs** for a list of genes. The output of TUX can be directly imported into GENIST to **predict causal relations** and the output of GENIST can be imported into programs like Cytoscape for visualization.

<iframe width="560" height="315" src="https://www.youtube.com/embed/b5iMvsaiBf8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## RTP-STAR
The RTP-STAR tab implements a **regression tree algorithm** (GENIE3) and uses **biological replicates of steady state gene expression data to infer GRNs** for a list of genes. The output of TUX can be directly imported into RTP-STAR to **predict causal relations** and the output of RTP-STAR can be imported into programs like Cytoscape for visualization.

<iframe width="560" height="315" src="https://www.youtube.com/embed/UOdSxLyAhq4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Additional Info

More details on running the software are provided in the following manuscript:
*TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks*

Please contact Ryan Spurney at <rjspurne@ncsu.edu>, Dr. Lisa Van den Broeck at <lfvanden@ncsu.edu>, or Dr. Ross Sozzani at <ross_sozzani@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
