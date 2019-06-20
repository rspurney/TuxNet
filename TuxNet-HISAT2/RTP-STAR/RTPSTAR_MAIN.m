%Run RTP-STAR a certain number of times. Each time, we
%save the final network that is created. At the end, we count the number of
%times each of the edges appears in a network and only keep edges over a
%certain proportion.
%
%GENIE3 code reference: Huynh-Thu V. A., Irrthum A., Wehenkel L., and Geurts P.
%Inferring regulatory networks from expression data using tree-based methods.
%PLoS ONE, 5(9):e12776, 2010. Original code available at
%https://github.com/vahuynh/GENIE3.
%
%Parameters:
%numiters: number of times to run RTP-STAR and combine results. default
%value = 1 (optional). We recommend up to 100 iterations if you are using
%spatial clustering as the first step is pseudorandom. If you are using
%temporal clustering or a user-provided list of clusters, there is not as much randomness,
%so we recommend <10 iterations (even 1 in most cases will suffice)
%
%maxprop: proportion of edges to keep. default value = 0.33 (1/3 of edges).
%This is only used if numiters >1 (optional)
%
%genes_file: .csv or .txt file that contains list of DE genes in 1 column
%(REQUIRED)
%
%expression_file: .csv or .txt file that contains the expression data for
%GRN inference. See below comments for proper formatting (REQUIRED)
%
%clustering_file: .csv or .txt file that contains the clustering data for
%GRN inference. See below comments for proper formatting (optional)
%
%time_file: .csv or .txt file that contains the timecourse data for
%GRN inference. See below comments for proper formatting (optional)
%
%symbol_file: .csv or .txt file that contains genes (column 1) and their
%known gene ID symbols (column 2) (optional)
%
%connecthubs: allows you to connect the hubs of each cluster, where hubs
%are defined as the node(s) with the most output edges in each cluster.
%Default is true (optional)
%
%clusteringseed: if you are clustering, a seed that you can set for the 
%clustering. Otherwise, the clustering is different every time. 
%Default is no seed (different clustering every time). (optional)
%
%clustering_type: variable denoting if you are using spatial or temporal
%clustering. Use "S" for spatial and "T" for temporal. Default is "S".
%(optional)
%
%usepresetclusters: set to "true" if you would like to upload your own
%cluster file to use. NOTE: function assumes your clustering file name is clusters.csv
%and has column 1 with gene names, column 2 whatever, and column 3 with cluster numbers.
%Default is false. (optional)
%
%presetclustersfile: file where your clusters are if you are uploading them
%(optional). Default is clusters.csv
%
%output_file: the name of the file where you want to write results. 
%Default name is biograph_final.txt
%
%Note that, using default settings, all results files will be saved to your
%current folder on MATLAB. Please check that you are in the correct folder
%before starting the pipeline.
%
%The final text file can be imported into software such as Cytoscape for
%network visualization.
%
%Expression data should be formatted as:
%Rows are genes, columns are experiments
%Column 1: genes
%Column 2: Indicator variable (1=TF, 0=non-TF)
%Columns 3 to X: expression data with biological replicates separate (you
%can use just means if you choose to)
%
%Clustering data should be formatted as:
%Rows are genes, columns are experiments
%Column 1: genes
%Columns 2 to X: mean gene expression data
%Note that clustering data are optional
%
%Time course data should be formatted as:
%Rows are genes, columns are experiments
%Column 1: genes
%Columns 2 to X: mean gene expression data
%Note that time course data are optional
%
%Author:
%Natalie M. Clark
%Email: nmclark2@iastate.edu
%Last updated: March 18, 2019

function RTPSTAR_MAIN(numiters, maxprop, genes_file, expression_file, clustering_file, timecourse_file, symbol_file, connecthubs, clusteringseed, clustering_type, usepresetclusters, presetclustersfile, output_file)

%check if variables exist and if not insert default values
if ~exist('numiters', 'var') || isempty(numiters)
    numiters = 1;
end
if ~exist('maxprop', 'var') || isempty(maxprop)
    maxprop = 0.33;
end
if ~exist('connecthubs', 'var') || isempty(connecthubs)
    connecthubs = true;
end
if ~exist('clusteringseed', 'var') || isempty(clusteringseed)
    clusteringseed = [];
end
if ~exist('clustering_type', 'var') || isempty(clustering_type)
    clustering_type = "S";
end
if ~exist('usepresetclusters', 'var') || isempty(usepresetclusters)
    usepresetclusters=false;
end
if ~exist('presetclustersfile', 'var') || isempty(presetclustersfile)
    presetclustersfile='clusters.csv';
end
if ~exist('output_file', 'var') || isempty(output_file)
    output_file = 'biograph_final.txt';
end

%read in DE genes
DE_genes = readtable(genes_file);

%read in file that contains expression data and get data for DE genes
expression = readtable(expression_file);
expression = expression(ismember(expression{:,1},DE_genes{:,1}),:);

%minimum number of edges to keep
%default is 2*number of TFs
%this is only used if the threshold is too restrictive
threshold = 2*sum(expression{:,2}==1);

%read in file that contains clustering data and get data for DE genes
if ~exist('clustering_file', 'var') || isempty(clustering_file)
    isclustering = false; 
    clustering=[];
else
    clustering = readtable(clustering_file);
    clustering = clustering(ismember(clustering{:,1},DE_genes{:,1}),:);
    isclustering=true;
end

%read in file that contains timecourse data and get data for DE genes
if ~exist('timecourse_file', 'var') || isempty(timecourse_file)
    istimecourse = false; 
    timecourse=[];
else
    timecourse = readtable(timecourse_file);
    timecourse = timecourse(ismember(timecourse{:,1},DE_genes{:,1}),:);
    istimecourse=true;
end


%read in file with gene names
if exist('symbol_file','var') && ~isempty(symbol_file)
    symbol = readtable(symbol_file);
else
    symbol = table(DE_genes,DE_genes);
end

%if only 1 iteration, only run the pipeline once
if numiters==1 && usepresetclusters==false
    clusterfile = 'clusters.csv';
    regression_tree_pipeline(expression,timecourse,clustering,symbol,...
    connecthubs, clusteringseed, isclustering, clustering_type, usepresetclusters, istimecourse,...
    [],clusterfile,[],[],output_file);
%if using preset clusters, load clusters from file
elseif numiters==1 && usepresetclusters==true
    isclustering=true;
    clusterfile = presetclustersfile;
    regression_tree_pipeline(expression,timecourse,clustering,symbol,...
    connecthubs, clusteringseed, isclustering, clustering_type, usepresetclusters, istimecourse,...
    [],clusterfile,[],[],output_file);
%otherwise, run the pipeline the provided number of iterations, and cluster
%the genes each time, using preset clusters if provided
elseif usepresetclusters==true
    isclustering=true;
    clusterfile = presetclustersfile;
    for i = 1:numiters
        graphfile = strcat('biograph',int2str(i),'.txt');
        regression_tree_pipeline(expression,timecourse,clustering,symbol,...
            connecthubs, clusteringseed, isclustering, clustering_type, usepresetclusters, istimecourse,...
            [],clusterfile,[],[],graphfile);
    end
else
    for i = 1:numiters
        clusterfile = strcat('clusters',int2str(i),'.csv');
        graphfile = strcat('biograph',int2str(i),'.txt');
        regression_tree_pipeline(expression,timecourse,clustering,symbol,...
            connecthubs, clusteringseed, isclustering, clustering_type, [], istimecourse,...
            [],clusterfile,[],[],graphfile);
    end
end

%read in all the files and get all of the unique edges
if numiters>1
    for i = 1:numiters
        if i == 1
            edges = readtable(strcat('biograph',int2str(i),'.txt'),'ReadVariableNames',false,'Delimiter','\n');
            edges = table2array(edges);
        else
            newedges = readtable(strcat('biograph',int2str(i),'.txt'),'ReadVariableNames',false,'Delimiter','\n');
            newedges = table2array(newedges);
            edges = [edges; newedges];
        end
    end
    edges = unique(edges);
    
    %read in each file
    %for each file, record which edges are present and add up how many times
    %the edges appear
    for i = 1:numiters
        network = readtable(strcat('biograph',int2str(i),'.txt'),'ReadVariableNames',false,'Delimiter','\n');
        network = table2array(network);
        presentedges = ismember(edges,network);
        if i == 1
            number = double(presentedges);
        else
            number = number+double(presentedges);
        end
    end
    proportions = table(edges, number);
    
    %if the number of edges with proportion >= maxprop is greater than the threshold
    %number of edges, we keep all of the edges with proportion >= maxprop
    %otherwise, we keep the maximum number of edges even though some of these
    %edges may have proportion < maxprop
    finaledges = sortrows(proportions,2,'descend');
    if table2array(finaledges(threshold,2)) < maxprop*numiters
        finaledges = finaledges(table2array(finaledges(:,2))>=table2array(finaledges(threshold,2)),:);
    else
        finaledges = finaledges(table2array(finaledges(:,2))>=maxprop*numiters,:);
    end
    
    %get weights for edges
    finaledges = table(finaledges{:,1},table2array(finaledges(:,2))./numiters,...
        'VariableNames',{'Edge','Weight'});
    
    %print edges to file
    writetable(finaledges,output_file,'Delimiter',' ','QuoteStrings',false,'WriteVariableNames',false);
end
end
    
        