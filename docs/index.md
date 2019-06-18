# Unfortunately, TuxNet access via TeamViewer has been permanently disabled. A new method for accessing TuxNet online is currently in development and will be described here once completed.

# TuxNet
Matlab app to process raw RNA-seq data and infer gene regulatory networks. Published and maintained by [Sozzani Lab](https://harvest.cals.ncsu.edu/sozzani-lab/) at North Carolina State University.

## Local Installation

The local use of TuxNet requires a 64-bit computer running Mac OS X (10.4 Tiger or later) with Matlab installed **(R2017b ONLY)**.

[GENIE3](https://github.com/jmlingeman/Network-Inference-Workspace/tree/master/algorithms/genie3) must be installed before the RTP-STAR tab can be run using TuxNet. To install GENIE3, download the top level .zip folder called Network-Inference-Workspace, unzip the files, and move Network-Inference-Workspace/algorithms/genie3 to a permanent location on your computer. The included README.txt will give detailed instructions on completing the installation. Make sure to add the genie3 folder with subfolders to your MATLAB path and to compile rtenslearn_c.c using the MATLAB 'mex' command.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml) must be installed before the TUX tab can be run using TuxNet. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation. Make sure to add the HISAT2 folder to your MATLAB path.

To run TuxNet, download all of the files from the [project repository](https://github.com/rspurney/TuxNet) as a .zip folder, and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then run the TuxNet.mlapp file.

More details on running the software are provided in the following manuscript:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks

## Contact Info

Please contact Ryan Spurney at <rjspurne@ncsu.edu> or Dr. Ross Sozzani at <rsozzan@ncsu.edu> with any questions or issues.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
