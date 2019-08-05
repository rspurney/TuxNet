TuxNet Linux Standalone

To install, execute 'sudo ./TuxNet-LinuxStandaloneInstaller.install' in the TuxNet-LinuxStandalone directory. You will be prompted to choose a directory where TuxNet will be installed and to install MATLAB Runtime if it is not already installed.

Note that you will need to install ea-utils, hisat2, SAMtools, and Cufflinks before using the TUX tab. Once installed, rename these folders to ea-utils, hisat2, samtools, and cufflinks, respectively, and move them into the same folder that run_TuxNet.sh and the other TuxNet files are located: '<TuxNetLocation>/application'.

To run TuxNet, execute 'sudo ./run_TuxNet.sh <mcr_directory>' where <mcr_directory> in the location where MATLAB Runtime is installed. For example: 'sudo ./run_TuxNet.sh /home/user/username/MATLAB_Runtime/v96'. You will be prompted to choose the current working directory via a file finder: '<TuxNetLocation>/application' should be your selection.