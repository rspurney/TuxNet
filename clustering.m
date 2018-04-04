%Determine appropriate number of clusters for gene expression data
%Saves the clusters to a file
%
%Parameters: 
%clustering_data: MATLAB table that contains
%clustering data, see below comments for proper formatting.
%
%symbol: MATLAB table that contains known symbols for some genes
%
%maxclusters: the maximum number of clusters to evaluate
%using Silhouette index. Default is floor(number of genes/10 + 5).
%
%filetowrite: the name of the file where you want to write results. Make
%sure to indicate the extension (file.txt, file.csv): otherwise, it
%defaults to a text file. Default name is clusters.csv
%
%clusteringseed: a seed that you can set for the clustering. Otherwise,
%the clustering is different every time. Default is no seed (different
%clustering every time).
%
%Assumes the excel file is formatted as:
%Rows are genes, columns are experiments
%Column 1: AGI numbers
%Columns 2 to X: mean gene expression data
%
%Returns:
%numclusters: the optimal number of clusters
%
%s: the silhouette values for each gene. A silhouette value close to 1
%indicates that gene is highly similar to all other genes in cluster
%
%Author:
%Natalie M. Clark
%Biomathematics Graduate Program
%North Carolina State University
%Email: nmclark2@ncsu.edu
%Last updated: November 3, 2016

function [numclusters] =  clustering(clustering_data,symbol, maxclusters,filetowrite,clusteringseed)

%check if parameters exist
%if not, set defaults
if ~exist('filetowrite', 'var') || isempty(filetowrite)
    filetowrite = 'clusters.csv';
end

%if we are using a seed, set it
%otherwise, shuffle the seed
if exist('clusteringseed', 'var') && ~isempty(clusteringseed)
    rng(clusteringseed);
else
    rng('shuffle');
end

%if maxclusters was not set, define it as floor(numgenes/10 + 5)
numgenes = size(clustering_data,1);
if ~exist('maxclusters', 'var') || isempty(maxclusters)
    maxclusters = floor(numgenes/10+5);
end
if floor(numgenes/10)<=5
    minclusters = floor(numgenes/10);
else
    minclusters = floor(numgenes/10-5);
end
if minclusters >= maxclusters
    minclusters = 1;
end

%set gene names
%if there is no gene name, use the AGI number
AGIs = table2cell(clustering_data(:,1));
symbols = table2cell(symbol(:,1:2));
genes = cell(length(AGIs),1);
isinfile = find(ismember(AGIs,symbols(:,1)));
notinfile = find(~ismember(AGIs,symbols(:,1)));
for i = 1:length(isinfile)
    index = isinfile(i);
    name_index = find(ismember(symbols(:,1),AGIs(index)));
    genes(index) = symbols(name_index,2);
end
for i = 1:length(notinfile)
    index = notinfile(i);
    genes(index) = AGIs(index);
end

%convert table to matrix without gene names
matrix = table2array(clustering_data(:,2:size(clustering_data,2)));


%Normalization 
    M = mean(matrix,2); % % compute the mean of each expression pattern
    S = std(matrix,0,2); % compute the variance of each expression pattern
    M_mat = M*ones(1,size(matrix,2));
    S_mat = S*ones(1,size(matrix,2));
    clust_data_norm = (matrix-M_mat)./S_mat; %dividing by std gives us unit var (rather than std)

%determine optimal number of clusters based on silhouette index
eva = evalclusters(clust_data_norm,'kmeans','silhouette', 'Klist', minclusters:maxclusters);

%perform clustering and check silhouette index
%want an index close to 1 for all genes
numclusters = eva.OptimalK;
clust = kmeans(clust_data_norm,numclusters);
%this will display the silhouette figure
%[s,~] = silhouette(clust_data_norm,clust);

%save clusters to file
clustering_data = table(AGIs,genes,clust);
writetable(clustering_data,filetowrite)
end
