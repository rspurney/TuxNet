####README for RTP-STAR####

Author:
Natalie M. Clark
Email: nmclark2@iastate.edu
Last updated: June 17, 2019

#########################################

GENIE3 code reference: Huynh-Thu V. A., Irrthum A., Wehenkel L., and Geurts P.
Inferring regulatory networks from expression data using tree-based methods.
PLoS ONE, 5(9):e12776, 2010. Original code available at
https://github.com/vahuynh/GENIE3.

##########################################

INSTALLATION

1) Download and extract the RTP-STAR .zip folder
2) Add the RTP-STAR folder to your path in MATLAB

##########################################

VERSION INFORMATION

RTP-STAR can be run on MATLAB 2014b and newer.

The Statistics and Machine Learning toolbox is required for the clustering step only. If you do not have this toolbox please contact nmclark2@iastate.edu for clustering code that does not require this toolbox.

###########################################

RUNNING INSTRUCTIONS

To run RTP-STAR, call the function RTPSTAR_MAIN from the MATLAB command window, entering whatever values/filenames you choose for each parameter:
RTPSTAR_MAIN(numiters, maxprop, genes_file, expression_file, clustering_file, timecourse_file, symbol_file, connecthubs, clusteringseed, clustering_type, usepresetclusters, presetclustersfile, output_file)

Your network will automatically be saved in the text file called output_file (default is biograph_final.txt if you do not provide a file name).

Note that only genes_file and expression_file are required to run RTP-STAR. The rest of the parameters can be left blank (to leave a parameter blank, enter [] for that parameter)

For example, if my gene file is called "genes.txt" and my expression file is called "expression.txt", here is how I would run RTP-STAR with all default parameters.
RTPSTAR_MAIN([],[],"genes.txt","expression.txt",[])

If I have additional files (clustering, timecourse, symbols), here is how I would run RTP-STAR with the additional files:
RTPSTAR_MAIN([],[],"genes.txt","expression.txt","clustering.txt","timecourse.txt","symbols.txt",[])

Note that MATLAB assumes that all of your files are in your current working directory. 
Also, using default settings, all results files will be saved to your current working directory on MATLAB. 
Please check that you are in the correct folder before starting the pipeline.

The final text file can be imported into software such as Cytoscape for network visualization.

##########################################

Information on parameters:

numiters: number of times to run RTP-STAR and combine results. default
value = 1 (optional). We recommend up to 100 iterations if you are using
spatial clustering as the first step is pseudorandom. If you are using
temporal clustering or a user-provided list of clusters, there is not as much randomness,
so we recommend <10 iterations (even 1 in most cases will suffice)

maxprop: proportion of edges to keep. default value = 0.33 (1/3 of edges).
This is only used if numiters >1 (optional)

genes_file: .csv or .txt file that contains list of DE genes in 1 column
(REQUIRED)

expression_file: .csv or .txt file that contains the expression data for
GRN inference. (REQUIRED)
Expression data should be formatted as:
Rows are genes, columns are experiments
Column 1: genes
Column 2: Indicator variable (1=TF, 0=non-TF). We include a file called "Arabidopsis_TFs_AGRIS.xlsx" that can be used to identify TFs for Arabidopsis samples.
Columns 3 to whatever: expression data with biological replicates separate (you
can use just means if you choose to, but RTP-STAR performance increases using replicates)

clustering_file: .csv or .txt file that contains the clustering data for
GRN inference. (optional)
Clustering data should be formatted as:
Rows are genes, columns are experiments
Column 1: genes
Columns 2 to whatever: average gene expression data for each clustering sample

time_file: .csv or .txt file that contains the timecourse data for
GRN inference. (optional)
Time course data should be formatted as:
Rows are genes, columns are experiments
Column 1: genes
Columns 2 to whatever: average gene expression data for each time point

symbol_file: .csv or .txt file that contains genes (column 1) and their
known gene ID symbols (column 2) (optional). We include a file called "Locus_Primary_Gene_Symbol_2013" that can be used for Arabidopsis gene symbols.

connecthubs: allows you to connect the hubs of each cluster, where hubs
are defined as the node(s) with the most output edges in each cluster.
Default is true (optional)

clusteringseed: if you are clustering, a seed that you can set for the 
clustering. Otherwise, the clustering is different every time. 
Default is no seed (different clustering every time). (optional)

clustering_type: variable denoting if you are using spatial or temporal
clustering. Use "S" for spatial and "T" for temporal. Default is "S".
(optional)

usepresetclusters: set to "true" if you would like to upload your own
cluster file to use. NOTE: function assumes your clustering file name is clusters.csv
and has column 1 with gene names, column 2 whatever, and column 3 with cluster numbers.
Default is false. (optional)

presetclustersfile: file where your clusters are if you are uploading them
(optional). Default is clusters.csv

output_file: the name of the file where you want to write results. 
Default name is biograph_final.txt

########################################
