
% to run, in addition to the code:
% 1) add the "readtable" lines that appear in this code
% 2) add a path variable to the subfolders of genie3
% 3) compilation required: type mex ./RT/rtree-c/rtenslearn_c.c if you are
% in the Regression_tree_pipeline directory

gene_file = '../HB13_with_PAN_data_without_PAN_genes/hb13_genes.xlsx';
expression_file = '../HB13_with_PAN_data_with_PAN_genes/hb13_genes_data.xlsx';
% expression_data = unique(readtable(char(expression_file)));
% clustering_data_file = '../Data for running RTP-STAR for paper/hb13_cluster_data.xlsx';
% clustering_data = unique(readtable(char(clustering_data_file)));

symbol_file = 'Locus_Primary_Gene_Symbol_2013.xlsx';
% symbol = readtable(char(symbol_file));

timecourse_file = '../HB13_with_PAN_data_with_PAN_genes/FPKM_stem_cell_time_course_rep_1.csv';
TF_file = 'Arabidopsis_TFs.xlsx';
clustering_file = [];%'../HB13_with_PAN_data_with_PAN_genes/hb13_cluster_data.xlsx';

connecthubs = true;
clusteringseed = 0;
isclustering = true;
usepresetclusters = false;
istimecourse = true;
maxclusters = [];
filename_cluster = [];%'clustering_output_HB13_genes';
timethreshold = [];
edgenumber = [];
filename_results = 'final_output_HB13_genes';
regression_tree_pipeline(gene_file, expression_file, clustering_file, symbol_file, timecourse_file, TF_file, connecthubs, clusteringseed, maxclusters, filename_cluster, timethreshold, edgenumber, filename_results)
