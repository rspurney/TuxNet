%Construct GRN using regression tree algorithm on an excel file
%Infers directionality using time course data
%
%Parameters:
%expression_data: MATLAB table that contains the expression data
%
%clusterfile: file that contains the genes and which cluster they are in
%
%symbol: MATLAB table that contains known symbols for some genes
%
%istimecourse:boolean variable (true/false) that indicates if you wish
%to use a timecourse for directionality. Default is true.
%
%selectedgenes: this allows you to run the network for only certain genes.
%This should be a cell array of the gene names as strings. This is not a
%required parameter and is not recommended for use outside of the pipeline
%file.
%
%clusternum: the cluster # you would like to run. Default is 1
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
%Returns 
%results: matrix with weights of edges from gene i to gene j
%
%threshold: weight cutoff used in final network
%
%bg2: final biograph
%
%clusterhub: the gene to be used to connect the cluster
%
%Assumes the expression data is formatted as:
%Rows are genes, columns are experiments
%Column 1: AGI numbers
%Column 2: binary indicator variable, 1 if known TF function, 0 if not
%Columns 3 to X: expression data
%Columns X+1 to Y: time course data for directionality
%
%Author:
%Natalie M. Clark
%Biomathematics Graduate Program
%North Carolina State University
%Email: nmclark2@ncsu.edu
%Last updated: November 3, 2016

function [results,threshold,bg2,mostout] = run_regressiontree(expression_data,clusterfile,symbol, istimecourse,selectedgenes,clusternum,timecols,timethreshold,edgenumber)

%check if parameters exist
%if not, set defaults
if ~exist('istimecourse', 'var') || isempty(istimecourse)
    istimecourse = true; 
end
if ~exist('clusternum', 'var') || isempty(clusternum)
    clusternum = 1; 
end
if ~exist('timecols', 'var') || isempty(timecols)
    timecols = 12; 
end
if ~exist('timethreshold', 'var') || isempty(timethreshold)
    timethreshold = 1.25;
end
if ~exist('edgenumber', 'var') || isempty(edgenumber)
    edgenumber = [0.5,1.5,2];
end

%get AGI numbers
AGIs = table2cell(expression_data(:,1));

%get TF information
isTF = table2array(expression_data(:,2));

%convert table to matrix without gene names
%if there is time course data, separate expression data and time course data
if istimecourse
    matrix = table2array(expression_data(:,3:size(expression_data,2)-timecols));
    timecourse = table2array(expression_data(:,size(expression_data,2)-timecols+1:size(expression_data,2)));
else
    matrix = table2array(expression_data(:,3:size(expression_data,2)));
end

%if we use clustering, use only genes in the applicable cluster
if exist('clusterfile', 'var') && ~isempty(clusterfile)
    %read in the clusters
    clustertable = readtable(clusterfile);
    clusters = clustertable(:,3);
    %get genes in cluster i
    clusteredgenes = clustertable(find(table2array(clusters)==clusternum),1);
    %find where those genes are in the expression data
    %this accounts for if the genes are not in the same order
    clusteredgenesindices = find(ismember(AGIs,table2array(clusteredgenes)));

    %select only the clustered genes we want to use
    matrix = matrix(clusteredgenesindices(:),:);
    if istimecourse
        timecourse = timecourse(clusteredgenesindices(:),:);
    end
    isTF = isTF(clusteredgenesindices(:));
    
    %get symbols for the genes
    symbols = table2cell(symbol(:,1:2));
    genes = cell(size(clusteredgenes,1),1);
    isinfile = find(ismember(clusteredgenes{:,:},symbols(:,1)));
    notinfile = find(~ismember(clusteredgenes{:,:},symbols(:,1)));
    for i = 1:length(isinfile)
        index = isinfile(i);
        name_index = find(ismember(symbols(:,1),clusteredgenes{index,:}));
        %if symbol is already in the list, this will throw an error
        %so if the symbol is already in use, don't use it
        if i > 1 && ismember(symbols(name_index,2),genes(~cellfun(@isempty,genes)))
            genes(index) = clusteredgenes{index,:};
        else
            genes(index) = symbols(name_index,2);
        end
    end
    for i = 1:length(notinfile)
        index = notinfile(i);
        genes(index) = clusteredgenes{index,:};
    end
else
    %if not clustering, still get symbols
    symbols = table2cell(symbol(:,1:2));
    genes = cell(length(AGIs),1);
    isinfile = find(ismember(AGIs,symbols(:,1)));
    notinfile = find(~ismember(AGIs,symbols(:,1)));
    for i = 1:length(isinfile)
        index = isinfile(i);
        name_index = find(ismember(symbols(:,1),AGIs(index)));
        %if symbol is already in the list, this will throw an error
        %so if the symbol is already in use, don't use it
        if i > 1 && ismember(symbols(name_index,2),genes(~cellfun(@isempty,genes)))
            genes(index) = AGIs(index);
        else
            genes(index) = symbols(name_index,2);
        end
    end
    for i = 1:length(notinfile)
        index = notinfile(i);
        genes(index) = AGIs(index);
    end
end

%if no TFs in the cluster, skip
%if only 1 gene, skip
if sum(isTF) == 0 || length(isTF) == 1
    results=[];
    bg2=[];
    threshold=[];
    mostout=[];
    return
end

%if we are only using certain genes, only use those genes
if exist('selectedgenes', 'var') && ~isempty(selectedgenes)
    selectedgenesindices = find(ismember(genes,selectedgenes));

    %select only the genes we want to use
    matrix = matrix(selectedgenesindices(:),:);
    if istimecourse
        timecourse = timecourse(selectedgenesindices(:),:);
    end
    genes = genes(selectedgenesindices(:));
    isTF = isTF(selectedgenesindices(:));
end


%transpose the matrix
%regression tree algorithm expects rows are experiments, columns are genes
matrix = matrix';

%get which genes are TFs
input_vec = find(isTF);

%run GENIE3
results = genie3(matrix,input_vec, 'RF', 'sqrt', 10000);

%make biograph 
bg1 = biograph(results,genes);

%get weights for the edges
edges = bg1.Edges;

%if there are no edges, we can skip the rest
if isempty(edges)
    threshold = 0;
    bg2 = bg1;
    mostout = {''};
else
    %remove low weights from results
    for i = 1:length(edges)
        edgeweights(i) = edges(i).Weight;
    end
    
    %sort the weights
    weights_sorted = sort(edgeweights,'descend');
    
    %determine the threshold
    %if there are only two nodes, we keep 1 edge
    if length(genes) <= 2
        numtokeep = 1;
    %if there are 3 nodes, we keep 5 edges
    elseif length(genes) == 3
        numtokeep = 5;
    %for all other edges, use predetermined threshold
    else
        %set thresholds based on number of TFs
        if sum(isTF)/length(genes) < 0.25
            numtokeep = floor(edgenumber(1)*length(genes));
        elseif sum(isTF)/length(genes) > 0.25 && sum(isTF)/length(genes)<0.5
            numtokeep = floor(edgenumber(2)*length(genes));
        else
            numtokeep = floor(edgenumber(3)*length(genes));
        end
    end
    %if the threshold is greater than the total number of edges, keep them all
    if numtokeep > numel(weights_sorted)
        threshold = 0;
    else
        threshold = weights_sorted(numtokeep);
    end
    
    %set anything below the threshold to zero so the edge does not appear
    %in the biograph
    cmatrix = results;
    for i = 1:size(results,1)
        for j = 1:size(results,2)
            if results(i,j) < threshold
                cmatrix(i,j) = 0;
            end
        end
    end
    
    %build final biograph
    bg2 = biograph(cmatrix,genes);
    
    %use timecourse for directionality, if applicable
    if istimecourse
        for i = 1:size(results,1)
            for j = 1:size(results,2)
                %checks that there is an interaction between gene A and gene B
                if cmatrix(i,j) ~= 0
                    %this counts the # of time points that indicate repression
                    repsum = 0;
                    %this counts the # of time points that indicate activation
                    actsum = 0;
                    for k = 1:size(timecourse,2)-2
                        %if gene A goes up, and gene B goes down, it's repression
                        %if gene A goes down, and gene B goes up, it's also
                        %repression
                        %fold change must be at least timethreshold to be significant
                        if timecourse(i,k+1)/timecourse(i,k) > timethreshold && timecourse(j,k+2)/timecourse(j,k+1) < timethreshold
                            repsum = repsum+1;
                        elseif timecourse(i,k+1)/timecourse(i,k) < timethreshold && timecourse(j,k+2)/timecourse(j,k+1) > timethreshold
                            repsum = repsum+1;
                            %if gene A goes up, and gene B goes up, it's activation
                            %if gene A goes down, and gene B goes down, it's also
                            %repression
                            %fold change must be at least timethreshold to be significant
                        elseif timecourse(i,k+1)/timecourse(i,k) > timethreshold && timecourse(j,k+2)/timecourse(j,k+1) > timethreshold
                            actsum = actsum+1;
                        elseif timecourse(i,k+1)/timecourse(i,k) < timethreshold && timecourse(j,k+2)/timecourse(j,k+1) < timethreshold
                            actsum = actsum+1;
                        end
                    end
                    %we check number of columns-2 time points
                    %and see if the majority are repression or activation
                    %use a strict majority
                    if repsum > floor(k/2)
                        %if repression, turn the edge red
                        edge = getedgesbynodeid(bg2, genes{i}, genes{j});
                        edge.LineColor = [1.0 0 0];
                    elseif actsum > floor(k/2)
                        %if activation, turn the edge green
                        edge = getedgesbynodeid(bg2, genes{i}, genes{j});
                        edge.LineColor = [0 1.0 0];
                    end
                end
            end
        end
    end
    
    %view the final biograph with directionality
    %view(bg2)
    
    %get stats (number of nodes, number of edges, etc)
    %get(bg2)
    
    %determine the node with the most output edges
    edges = bg2.edges;
    for i = 1:length(edges)
        %get all of the regulators for each edge
        current_edge = edges(i).ID;
        edge_split = strsplit(current_edge,' -> ');
        regulators(i) = edge_split(:,1);
    end
    
    %find the regulator names
    regulator_names = unique(regulators);
    %for each regulator, count the number of times it appears
    for i = 1:length(regulator_names)
        repsum=0;
        for j = 1:length(regulators)
            if strcmp(char(regulators(j)),char(regulator_names(i))) == 1
                repsum = repsum+1;
            end
        end
        totals(i)=repsum;
    end
    
    %return the node with the most regulation
    %if there is a tie, keep both
    maxedges = max(totals);
    bestregulators = find(totals==maxedges);
    mostout = regulator_names(bestregulators);
end
    
end


           
