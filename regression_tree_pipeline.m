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
%istimecourse:boolean variable (true/false) that indicates if you wish
%to use a timecourse for directionality. Default is true.
%
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

function regression_tree_pipeline(expression_data, clustering_data, symbol, connecthubs, clusteringseed, isclustering, istimecourse, maxclusters, filename_cluster, timecols, timethreshold, filename_results)

%check if parameters exist
%if not, set defaults
if ~exist('isclustering', 'var') || isempty(isclustering)
    isclustering = true; 
end
if ~exist('istimecourse', 'var') || isempty(istimecourse)
    istimecourse = true; 
end
if ~exist('filename_cluster', 'var') || isempty(filename_cluster)
    filename_cluster = 'clusters.csv';
end
if ~exist('timecols', 'var') || isempty(timecols)
    timecols = 5; 
end
if ~exist('timethreshold', 'var') || isempty(timethreshold)
    timethreshold = 1;
end
if ~exist('connecthubs', 'var') || isempty(connecthubs)
    connecthubs=false;
end
if ~exist('filename_results', 'var') || isempty(filename_results)
    filename_results = 'biograph.txt';
end

%check if maxclusters has been defined
%if not, make it empty so that default can be set in clustering algorithm
if ~exist('maxclusters', 'var')
    maxclusters = [];
end

if isclustering
    %check if using a seed
    if ~exist('clusteringseed', 'var') || isempty(clusteringseed)
       [numclusters] =  clustering(clustering_data,symbol,maxclusters,filename_cluster,[]);
    else
       [numclusters] =  clustering(clustering_data,symbol,maxclusters,filename_cluster,clusteringseed);
    end
 end
% numclusters=2;
% end

%run inference step for each cluster
%each biograph will print separately
%if not clustering, we just run once
if ~exist('numclusters', 'var') || isempty(numclusters)
    [~,~,bg2,~] = run_regressiontree(expression_data,[],symbol, istimecourse,[],[],timecols,timethreshold);
    biograph_to_text(bg2,istimecourse,filename_results);
    final_table = readtable(char(filename_results),'ReadVariableNames',false);
    unique_edges = unique(table2cell(final_table));
    writetable(cell2table(unique_edges),char(filename_results),'WriteVariableNames',false)
else
    currentindex = 1;
    for i = 1:numclusters
        [~,~,bg2,clusterhub] = run_regressiontree(expression_data,filename_cluster,symbol,istimecourse,[],i,timecols,timethreshold);
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
        end
    end
    %connect the clusters, if applicable
    if connecthubs
        [~,~,bg2,~]=run_regressiontree(expression_data,[],symbol,istimecourse,clusterhub_vec,[],timecols,timethreshold);
        %print results
        biograph_to_text(bg2,istimecourse,char(filename_results));
    end
    
    %there may be duplicate edges in the final file, so we need to remove
    %them
    final_table = readtable(char(filename_results),'ReadVariableNames',false);
    unique_edges = unique(table2cell(final_table));
    writetable(cell2table(unique_edges),char(filename_results),'WriteVariableNames',false)
    
end