# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks from the processed data. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

# Table of Contents
1. [Remote Access](#remote-access)
2. [TUX](#tux)
3. [GENIST](#genist)
4. [RTP-STAR](#rtp-star)
5. [Local Installation](#local-installation)
6. [Contact Info](#contact-info)

## Remote Access

TuxNet can be remotely accessed and run using TeamViewer. A tutorial video is provided below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/cUXHW89-wi0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<br />

**Partner ID: 1332421847**

**TeamViewer Authentication Password: TuxNet**

**Mac Account Name: TuxNet**

**Mac Account Password: TuxNet**

1. Download and install [TeamViewer](https://www.teamviewer.com/en-us/download/windows/).
1. In the Partner ID field under the Control Remote Computer section of the app, enter **1332421847**.
1. In the TeamViewer Authentication popup, enter **TuxNet** as the password.

    TeamViewer will now attempt to remotely connect. If the computer is currently in use, TeamViewer will prompt the current user to either accept or deny your remote access request. If they deny your request, try to log in again at a later time.

1. If TeamViewer has successfully connected, you should see a Mac login screen. Enter **TuxNet** as both the name and password.
1. If the login information is entered correctly, you should see a Mac desktop screen. From here, import the files you want to run in TuxNet via the Files & Extras tab at the top of the screen.
1. Double-click on the TuxNet App shortcut on the desktop. Matlab will open, and then TuxNet will open. From here, follow tab specific instructions ([TUX](#tux), [GENIST](#genist), [RTP-STAR](#rtp-star)) to run TuxNet and process your data.
1. When you are done processing your data, transfer the results files you want back to your local computer via the Files & Extras tab at the top of the screen.
1. Finally, once you have transferred all of the data you want to keep back to your local computer, delete all imported and generated files from the remote access TuxNet computer and close TuxNet and Matlab.

## TUX

The TUX tab allows users to process raw RNA-seq data and to perform differentially expressed gene (DEG) comparisons between sample groups. A tutorial video is provided below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/0_v7WvRm418" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<br />

1. Open the TuxNet app via shortcut or through Matlab.
1. Select your inputs folder under the Cleaning Options section. The raw data must be in the **.fastq.gz** file format. These raw files must be organized into folders by sample groug, and all of these sample group folders must be placed inside a top level folder. An example of correct file organization is shown below.

<img src="https://github.com/rspurney/TuxNet/blob/master/docs/media/inputs.JPG" alt="drawing" width="200"/>

1. Double-click on the TuxNet App shortcut on the desktop. Matlab will open, and then TuxNet will open. From here, follow tab specific instructions ([TUX](#tux), [GENIST](#genist), [RTP-STAR](#rtp-star)) to run TuxNet and process your data.
1. When you are done processing your data, transfer the results files you want back to your local computer via the Files & Extras tab at the top of the screen.
1. Finally, once you have transferred all of the data you want to keep back to your local computer, delete all imported and generated files from the remote access TuxNet computer and close TuxNet and Matlab.

## GENIST

(GENIST tutorial)

## RTP-STAR

(RTP-STAR tutorial)

## Local Installation

The local use of TuxNet requires a 64-bit computer running Mac OS X (10.4 Tiger or later), with Matlab installed **(R2017b ONLY)**.

[GENIE3](https://github.com/aertslab/GENIE3) must be installed before the RTP-STAR tab can be run using TuxNet. To install GENIE3, download the MATLAB .zip folder, unzip the files, and follow the installation instructions included in the documentation.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml) must be installed before the TUX tab can be run using TuxNet. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation.

To run TuxNet, download all of the files from the [project repository](https://github.com/rspurney/TuxNet) as a .zip folder, and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then run the TuxNet.mlapp file.

More details on running the software are provided in the following manuscript:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks

## Contact Info

Please contact Ryan Spurney at <rjspurne@ncsu.edu> or Dr. Ross Sozzani at <rsozzan@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
