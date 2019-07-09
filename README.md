# TuxNet
Matlab App to process raw RNA-seq data and infer GRNs from the processed data. Published and maintained by Sozzani Lab at North Carolina State University.

Visit https://rspurney.github.io/TuxNet/ for tutorials on remotely accessing and running TuxNet.

To run TuxNet, download all of the files from the [project repository](https://github.com/rspurney/TuxNet) and unzip the folder. To run TuxNet for the first time using Arabidopsis data, unzip genome.fa.zip (included in the folder). Then, run the TuxNet.mlapp file.

The MATLAB [Bioinformatics Toolbox](https://www.mathworks.com/products/bioinfo.html) and [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) are both required to run GENIST and RTP-STAR.

[HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml) must be installed before the TUX tab can be run using TuxNet. To install HISAT2, download the correct binary and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make'. **Once this is done, you must copy the HISAT2 folder into the TuxNet-HISAT2 folder and change the HISAT2 folder name to 'hisat2'. Otherwise, TuxNet will not be able to find the HISAT2 files.**

[Cufflinks](https://cole-trapnell-lab.github.io/cufflinks/) must be installed before the TUX tab can be run using TuxNet. To install Cufflinks, download the correct binary and unzip the file. **Once this is done, you must copy the Cufflinks folder into the TuxNet-HISAT2 folder and change the Cufflinks folder name to 'cufflinks'. Otherwise, TuxNet will not be able to find the Cufflinks files.**

[ea-utils](https://expressionanalysis.github.io/ea-utils/) must be installed before the TUX tab can be run using TuxNet. To install ea-utils, download and unzip the file and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make install'. **Once this is done, you must copy the ea-utils folder into the TuxNet-HISAT2 folder and change the ea-utils folder name to 'ea-utils'. Otherwise, TuxNet will not be able to find the ea-utils files.**

[SAMtools](http://samtools.sourceforge.net/) must be installed before the TUX tab can be run using TuxNet. To install SAMtools, download and unzip the file and follow the installation instructions included in the documentation. For Mac and Linux, this will involve navigating to the downloaded directory via command line and running 'make install'. **Once this is done, you must copy the SAMtools folder into the TuxNet-HISAT2 folder and change the SAMtools folder name to 'samtools'. Otherwise, TuxNet will not be able to find the SAMtools files.**


More details on running the software are provided in the following manuscript:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks

----------------------------------------------------------------------------------------------------------------------------
REFERENCES:
TuxNet: A simple interface to process RNA sequencing data and infer gene regulatory networks
