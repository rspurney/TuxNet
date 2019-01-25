# TuxNet
Matlab App to process raw RNA-seq data and infer GRNs from the processed data. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

# Table of Contents
1. [Remote Access](#remote-access)
2. [GENIST Tutorial](#genist-tutorial)
3. [RTP-STAR Tutorial](#rtp-star-tutorial)
4. [Local Installation](#local-installation)

## Remote Access

TuxNet can be remotely accessed and run using TeamViewer. A tutorial video is provided below.

<video src="media/RemoteAccessTutorial.mp4" width="320" height="200" controls preload></video>

**Partner ID: 1332421847**

**TeamViewer Authentication Password: TuxNet**

**Mac Account Name: TuxNet**

**Mac Account Password: TuxNet**

1. Download and install [TeamViewer](https://www.teamviewer.com/en-us/download/windows/).
1. In the Partner ID field under the Control Remote Computer section of the app, enter **1332421847**.
1. In the TeamViewer Authentication popup, enter **TuxNet** as the password.

    TeamViewer will now attempt to remotely connect. If the computer is currently in use, TeamViewer will prompt the current user to either accept or deny your remote access request. If they deny your request, try to log in again at a later time.

1. If TeamViewer has successfully connected, you should see a Mac login screen. Enter **TuxNet** as both the name and password.

## GENIST Tutorial

## RTP-STAR Tutorial

## Local Installation

The local use of TuxNet requires a 64-bit computer running Mac OS X (10.4 Tiger or later), with Matlab installed **(R2017b ONLY)**.

[GENIE3](https://github.com/jmlingeman/Network-Inference-Workspace/tree/master/algorithms/genie3) must be installed before the RTP-STAR tab can be run using TuxNet. To install GENIE3, download the MATLAB .zip folder, unzip the files, and follow the installation instructions included in the documentation.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml) must be installed before the TUX can be run using TuxNet. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation.

To run TuxNet, download all the files from this folder as a .zip folder, and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then run the TuxNet.mlapp file.

Details to run the software are provided in the following manuscript:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
