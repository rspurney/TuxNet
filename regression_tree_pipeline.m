%NOTE: This requires the Statistics and Machine Learning and Bioinformatics
%toolboxes.

%This file runs the regression tree pipeline for GRN inference. Genes are
%first clustered (if applicable) and then networks for each cluster are
%inferred. If there are multiple clusters, clusters are connected using the
%same inference algorithm. The final network is printed to a textfile that
%can be uploaded into Cytoscape for network visualization.
%
%Parameters:
%expression_data: MATLAB table that contains the expression data, see below
%comments for proper formating.
%
%clustering_data: if you are clustering, MATLAB table that contains
%clustering data, see below comments for proper formatting.
%
%clusteringseed: if you are clustering, a seed that you can set for the 
%clustering. Otherwise, the clustering is different every time. 
%Default is no seed (different clustering every time).
%
%symbol: MATLAB table that contains known symbols for some genes
%
%isclustering: boolean variable (true/false) that indicates if you wish
%to cluster your genes before inferring networks. Default is true.
%
%usepresetclusters: boolean variable (true/false) that indicates if you
%wish to upload your own cluster file to use. If you use this option, the
%cluster file MUST be named filename_cluster.
%
%istimecourse:boolean variable (true/false) that indicates if you wish
%to use a timecourse for directionality. Default is true.
%
%maxclusters:the maximum number of clusters to evaluate
%using Silhouette index. Default is floor(p/10 + 5) where p is the number
%of genes.
%
%filename_cluster: the name of the file where you want to write
%clustering results. Make sure to indicate the extension (file.txt, file.csv):
%otherwise, it defaults to a text file. Default name is clusters.csv
%
%timecols: the number of columns in the file that are time course
%data for use in directionality algorithm. Default is 12
%
%timethreshold: fold change cutoff to use in directionality algorithm.
%Default is 1.25
%
%edgenumber: vector of 3 values that represent the thresholds to be used
%during the inference. The 3 values represent the multiplier to be used on
%the number of edges kept for a low, medium, and high number of TFs.
%
%connecthubs: allows you to connect the hubs of each cluster, where hubs
%are defined as the node(s) with the most output edges in each cluster. Default is true
%
%filename_results: the name of the file(s) where you want to write results. 
%Default name is biograph.txt. If clustering, files will be indexed based
%on cluster number. If clustering, your final network will be your chosen
%filename+final.txt.
%
%Note that, using default settings, all results files will be saved to your
%current folder on MATLAB. Please check that you are in the correct folder
%before starting the pipeline.
%
%
%The final text file can be imported into software such as Cytoscape for
%network visualization.
%
%Clustering data should be formatted as:
%Rows are genes, columns are experiments
%Column 1: AGI numbers
%Columns 2 to X: mean gene expression data
%
%Inference data should be formatted as:
%Rows are genes, columns are experiments
%Column 1: AGI numbers
%Column 2: binary indicator variable, 1 if known TF function, 0 if not
%Columns 3 to X: expression data with biological replicates separate (you
%can use just means if you choose to)
%Columns X+1 to Y: time course data for directionality (optional. If you
%aren't using a timecourse for directionality, make sure to set
%istimecourse to false).
%
%Author:
%Natalie M. Clark
%Biomathematics Graduate Program
%North Carolina State University
%Email: nmclark2@ncsu.edu
%Last updated: November 3, 2016

function regression_tree_pipeline(gene_file, expression_file, clustering_file, symbol_file, timecourse_file, TF_file, connecthubs, clusteringseed, maxclusters, filename_cluster, timethreshold, edgenumber, filename_results)

%check if parameters exist
%if not, set defaults
usepresetclusters = false; 

if ~exist('clustering_file', 'var') || isempty(clustering_file)
     isclustering = false; 
else
     isclustering = true; 
end   
if ~exist('timecourse_file', 'var') || isempty(timecourse_file)
    istimecourse = false; 
else
    istimecourse = true; 
end
if ~exist('filename_cluster', 'var') || isempty(filename_cluster)
    filename_cluster = 'clusters.csv';
end
if ~exist('timethreshold', 'var') || isempty(timethreshold)
    timethreshold = 1.25;
end
if ~exist('edgenumber', 'var') || isempty(edgenumber)
    edgenumber = [0.5,1.5,2];
end
if ~exist('connecthubs', 'var') || isempty(connecthubs)
    connecthubs=false;
end
if ~exist('filename_results', 'var') || isempty(filename_results)
    filename_results = 'biograph.txt';
end

gene_data = sortrows(readtable(char(gene_file)));
expression_data = sortrows(readtable(char(expression_file))); 
if ~exist('TF_file', 'var') || isempty(TF_file)
    TFs = gene_data;
else
    TFs = readtable(char(TF_file));
end

if length(table2array(gene_data(:,1))) > length(table2array(expression_data(:,1)))
    error('The expression data file must contain expression values for all the genes provided in gene file.')
end

if ~exist('symbol_file', 'var') || isempty(symbol_file)
    tmp(:,1)=gene_data(:,1);
    tmp(:,2)=gene_data(:,1);
    symbol = tmp;
else
    symbol = sortrows(readtable(char(symbol_file)));
end

mygenes = unique(gene_data(:,1)); 
mygenes(:,2) = table(ismember(mygenes{:,1},TFs{:,1})); 
mygenes = sortrows(mygenes); 

expression_data = join(mygenes,expression_data,'Keys',[1,1]); 

if ~exist('timecourse_file', 'var') || isempty(timecourse_file) 
    timecols = 5;
else
    timecourse_data = sortrows(readtable(char(timecourse_file))); 
    timecols = size(timecourse_data,2);
    expression_data = join(expression_data,timecourse_data,'Keys',[1,1]); 
end 

%check if maxclusters has been defined
%if not, make it empty so that default can be set in clustering algorithm
if ~exist('maxclusters', 'var')
    maxclusters = [];
end

if isclustering
    clustering_data = sortrows(readtable(char(clustering_file))); 
    
    if length(table2array(gene_data(:,1))) > length(table2array(clustering_data(:,1)))
        error('The clustering data file must contain expression values for all the genes provided in gene file.')
    end
    
    clustering_data = clustering_data(ismember(clustering_data{:,1},mygenes{:,1}),:);  
    if ~usepresetclusters 
        %check if using a seed
        if ~exist('clusteringseed', 'var') && isempty(clusteringseed)
            [numclusters] =  clustering(clustering_data,symbol,maxclusters,filename_cluster,[]);
        else
            [numclusters] =  clustering(clustering_data,symbol,maxclusters,filename_cluster,clusteringseed);
        end
    elseif usepresetclusters
        myclusters = readtable(filename_cluster);
        numclusters = max(myclusters{:,3});
    end
end

%run inference step for each cluster
%each biograph will print separately
%if not clustering, we just run once
if ~exist('numclusters', 'var') || isempty(numclusters)
    [~,~,bg2,~] = run_regressiontree(expression_data,[],symbol, istimecourse,[],[],timecols,timethreshold,edgenumber);
    biograph_to_text(bg2,istimecourse,filename_results);
    final_table = readtable(char(filename_results),'ReadVariableNames',false);
    unique_edges = unique(table2cell(final_table));
    writetable(cell2table(unique_edges),char(filename_results),'WriteVariableNames',false)
    view(bg2)
else
    currentindex = 1;
    for i = 1:numclusters
        [~,~,bg2,clusterhub] = run_regressiontree(expression_data,filename_cluster,symbol,istimecourse,[],i,timecols,timethreshold,edgenumber);
        %store node(s) with most output edges for each cluster
        if numel(clusterhub) == 1
            clusterhub_vec(1,currentindex) = clusterhub;
            currentindex = currentindex + 1;
        elseif numel(clusterhub) > 1
            clusterhub_vec(1,currentindex:(currentindex+numel(clusterhub)-1)) = clusterhub;
            currentindex = currentindex+numel(clusterhub);
        end
        %print results to text file for cytoscape for each cluster
        %just one text file will contain the entire network
        if ~isempty(bg2)
            biograph_to_text(bg2,istimecourse,char(filename_results))
            view(bg2)
        end
    end
    %connect the clusters, if applicable
    if connecthubs
        [~,~,bg2,~]=run_regressiontree(expression_data,[],symbol,istimecourse,clusterhub_vec,[],timecols,timethreshold,edgenumber);
        %print results
        biograph_to_text(bg2,istimecourse,char(filename_results));
        view(bg2)
    end
    
    %there may be duplicate edges in the final file, so we need to remove
    %them
    final_table = table2cell(readtable(char(filename_results),'ReadVariableNames',false));
    final_table_merged = strcat(final_table(:,1),final_table(:,3)); 
    [~,unique_edges_idx,~] = unique(final_table_merged); 
    unique_edges = final_table(unique_edges_idx,:); 
    writetable(cell2table(unique_edges),char(filename_results),'WriteVariableNames',false)
    
end