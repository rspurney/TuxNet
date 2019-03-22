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
2. In the Partner ID field under the Control Remote Computer section of the app, enter **1332421847**.
3. In the TeamViewer Authentication popup, enter **TuxNet** as the password. TeamViewer will now attempt to remotely connect. If the computer is currently in use, TeamViewer will prompt the current user to either accept or deny your remote access request. If they deny your request, try to log in again at a later time.
4. If TeamViewer has successfully connected, you should see a Mac login screen. Enter **TuxNet** as both the name and password.
5. If the login information is entered correctly, you should see a Mac desktop screen. From here, import the files you want to run in TuxNet via the Files & Extras tab at the top of the screen.
6. Double-click on the TuxNet App shortcut on the desktop. Matlab will open, and then TuxNet will open. From here, follow tab specific instructions ([TUX](#tux), [GENIST](#genist), [RTP-STAR](#rtp-star)) to run TuxNet and process your data.
7. When you are done processing your data, transfer the results files you want back to your local computer via the Files & Extras tab at the top of the screen.
8. Finally, once you have transferred all of the data you want to keep back to your local computer, delete all imported and generated files from the remote access TuxNet computer and close TuxNet and Matlab.

## TUX

The TUX tab allows users to process raw RNA-seq data and to perform differentially expressed gene (DEG) comparisons between sample groups. A tutorial video is provided below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/0_v7WvRm418" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

1. Open the TuxNet app via shortcut or through Matlab.
2. Select your inputs folder under the Cleaning Options section. The raw data must be in the **.fastq.gz** file format. These raw files must be organized into folders by sample groug, and all of these sample group folders must be placed inside a top level folder. An example of correct file organization is shown below. The user would select the "Data" folder as their input folder in TuxNet to run the raw data from sample groups T0, T1, and T2.

    <img src="media/correct_inputs.JPG" alt="Correct Inputs" width="500"/>

    <br />

3. Check the remaining options in the Cleaning Options and Tuxedo Options sections: Quality Threshold, Min Sequence Length, Window-Size, Threads, Reference Genome, Library Type, and FASTA File. Default values are prefilled for these options so TUX can be run without changing any of them.
4. Press the Run button in the bottom left corner to process the raw data. Execution time depends on file size and quantity, but generally takes several hours. If any errors occur, please contact us using the information provided [here](#contact-info).
5. To compare DEGs between sample groups, fill in the TuxOP Options section. FC Threshold, FDR Threshold, TF File, and Gene Names File are prefilled by default.
6. Sample Group 1 and Sample Group 2 should chosen from the names of the sample group folders in your inputs folder. For the example image shown above, the user could choose Sample Group 1 as T0 and Sample Group 2 as T2 to compare T0 to T2. Alternatively, they could select Sample Group 2 as T1,T2 to compare T0 to compare T0 to T1 and T2.
7. Output files will be moved to the same folder the inputs files are located in when the run is complete.

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
