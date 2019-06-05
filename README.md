# TuxNet
Matlab App to process raw RNA-seq data and infer GRNs from the processed data. Published and maintained by Sozzani Lab at North Carolina State University.

Visit https://rspurney.github.io/TuxNet/ for tutorials on remotely accessing and running TuxNet.

The use of TuxNet locally requires a 64-bit computer running Mac OS X (10.4 Tiger or later) with Matlab installed (R2017b ONLY).

GENIE3, available from https://github.com/jmlingeman/Network-Inference-Workspace/tree/master/algorithms/genie3, must be also installed before RTP-STAR can be run using TuxNet. To install GENIE3, download the top level .zip folder called Network-Inference-Workspace, unzip the files, and move Network-Inference-Workspace/algorithms/genie3 to a permanent location on your computer. The included README.txt will give detailed instructions on completing the installation. Make sure to add the genie3 folder with subfolders to your MATLAB path and to compile rtenslearn_c.c using the MATLAB 'mex' command.

HISAT2, available from https://ccb.jhu.edu/software/hisat2/index.shtml, must be installed before the TUX tab of the HISAT2 version of TuxNet can be run. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation. Make sure to add the HISAT2 folder to your MATLAB path.

To run TuxNet, download all the files from this folder as a .zip folder, and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then open the TuxNet.mlapp file, included in the folder.   

Details to run the software are provided in the following manuscript:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks.

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
