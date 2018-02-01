function GENIST2_0(genes_file,time_course_file,clustering_data_file,time_lapse,is_load_new_data,TF_file,symbol_file,is_reg_fc_th,is_reg_time_percent,n_levels,is_low_conn)
%%
% Inference of Gene Regulatory Networks (GRNs) from spatio temporal data
%
%
% GENIST2_0(genes_file,time_course_file,clustering_data_file)
% infers regulations among the genes provided in genes_file. The
% regulations are calculated by applying a first step of clustering that
% groups the genes based on their coexpression in the clustering_file data
% (which should be preferently a spatial dataset) followed by a second step
% of a Bayesian Network inference, which uses the data in time_course_file.
% genes_file must be an excel file containing the list of genes to be
% included in the network as a column.
%
% time_course_file must be an excel file containing expression data of
% the genes across different time or developmental time points. Each
% row must correspond to 1 gene. The file can contain any number of
% genes, and GENIST selects the genes specified in genes_file.
%
% clustering_data_file must be an excel file containing expression data
% of the genes across different spacial confinements. Each
% row must correspond to 1 gene. The file can contain any number of
% genes, and GENIST selects the genes specified in genes_file.
% The names of the genes in all .xlsx files must be consistent.
%
%
%
% GENIST2_0(genes_file,time_course_file,clustering_data_file,time_lapse,is_load_new_data)
% sets the values of time_lapse and is_load_new_data.
% time_lapse indicates the lapse between the activation of genes that
% the algorithm will consider to select the regulators of a gene.
% If time_lapse is 1, GENIST assumes that genes that are active in one
% time point can regulate other genes in the following time point.
% If time_lapse is 0, GENIST assumes that genes that are active in one
% time point can regulate other genes in the same time point. 
% If time_lapse is [0,1], GENIST assumes that genes that are active in one
% time point can regulate other genes in the same time point or in the
% following time point. Default is 1.
%
% If is_load_new_data is true, all data is loaded and saved into a Matlab.
% If is_load_new_data is false, the data last saved is used to run GENIST.
% Default is true.
%
%
% GENIST2_0(genes_file,time_course_file,clustering_data_file,time_lapse,is_load_new_data,TF_file,symbol_file)
% sets a list of Transcription Factors (TFs) and symbols of the genes.
% TF_file must be an excel file containing a list of TFs as a column
% vector. If TF_file is provided, only the genes (from genes_gile) that
% are also included in the TF_file will be considered as potential
% regulators in the network.
%
% symbol_file must be an excel file containing a list of genes in the
% first column, and a corresponding symbol for each gene in the second
% column. When symbol_file is provided, the genes in the network for
% which a symbol was provided are represented by their symbol.
% The names of the genes in all .xlsx files must be consistent.
%
%
% GENIST2_0(genes_file,time_course_file,clustering_data_file,time_lapse,is_load_new_data,TF_file,symbol_file,is_reg_fc_th,is_reg_time_percent,n_levels,is_low_conn)
% sets the values of is_reg_fc_th, is_reg_time_percent, n_levels, and 
% is_low_conn.
% is_reg_fc_th is the minimum (threshold) fold-change expression that a 
% gene must experience between two consecutive time points for it to be 
% considered a potential regulator of another gene that is changing its
% expression (also by at least a is_reg_fc_th fold-change) in the same
% (time_lapse == 0) or the next (time_lapse == 1) time point. Default is
% 1.3.
%
% is_reg_time_percent is the minimun percentage of the total time points
% that a potential regulator and a target show simultaneous  
% (if time_lapse == 0) or consecutive (if time_lapse == 1) changes of
% expression for a gene to be considered a potential regulator of the
% target gene. Default is 0.3.  
%
% n_levels is the number of levels in which the time course expression data
% will be discretized for calculating the probabilities that each potential
% regulator regulates each target. Must be an integer. Default is 2.
% Minimum allowed value is 2. Recommended values 2 or 3. 
%
% is_low_conn sets the bottom percentage of regulations of the final
% network that will be condirered too low to be displayed (will be
% discarded). Default is 0.2.
%
%
% GENIST2_0 returns a plot of the resulting network in MATLAB, as well as a
% file that is saved as 'cityscape_table' in the working directory. This
% file contains a table with all the regulations of the network. This file
% can be imported into cytocape to generate a plot of the network.
%
%
% Example 1:
% GENIST2_0('gene_list.xlsx','DevTime','spatial_test',1,true,'Arabidopsis_TFs','Locus_Primary_Gene_Symbol_2013')
% Example 2:
% GENIST2_0('gene_list.xlsx','DevTime','spatial_test',1,false)
% Example 3:
% GENIST2_0('gene_list.xlsx','DevTime','spatial_test')
% Example 4:
% GENIST2_0('gene_list.xlsx','DevTime','spatial_test',1,true,[],'Locus_Primary_Gene_Symbol_2013')
% Example 5:
% GENIST2_0('gene_list.xlsx','DevTime','spatial_test',[0,1],true,[],'Locus_Primary_Gene_Symbol_2013',[],.1,[],0.4)
% Example 6:
% genes = 'gene_list.xlsx';
% time_course = 'DevTime.xlsx';
% clustering_data = '../spatial_test.xlsx';
% TF_list = 'Arabidopsis_TFs.xlsx';
% symbols = 'Locus_Primary_Gene_Symbol_2013.xlsx';
% GENIST2_0(genes,time_course,clustering_data,[0,1],true,TF_list,symbols,1.5,.1,3,0.4)

%
% M. Angels de Luis Balaguer
% Postdoctoral Research Scholar
% North Carolina State University
% 2016

%% Load data %%

global TF
global symbol

if nargin < 3
    error('Not enough input arguments. Provide at least genes, time_course, and clustering_data.')
end

if ~exist('is_load_new_data', 'var') || isempty(is_load_new_data)
    is_load_new_data = true;
end
if ~exist('time_lapse', 'var') || isempty(time_lapse)
    time_lapse = 1;
end
if ~exist('is_reg_fc_th', 'var') || isempty(is_reg_fc_th)
    is_reg_fc_th = 1.3;
end
if ~exist('is_reg_time_percent', 'var') || isempty(is_reg_time_percent)
    is_reg_time_percent = 0.3;
end
if ~exist('n_levels', 'var') || isempty(n_levels)    
    n_levels = 2;
end
if ~exist('is_low_conn', 'var') || isempty(is_low_conn)    
    is_low_conn = 0.2;   
end

if nargin >= 4
    if length(time_lapse) == 2
        if time_lapse(1) == 0 && time_lapse(2) == 1
            time_lapse = -1;
        end
    end       
    if (time_lapse ~= 0 && time_lapse ~= 1 && time_lapse ~= -1)
        error('time_lapse must be 0, 1, or [0,1]')
    end
end
if nargin >= 5 
    if ~isa(is_load_new_data,'logical')
        error('is_load_new_data must be true or false')
    end
end
if nargin >= 8
    if is_reg_fc_th < 1
        error('is_reg_fc_th must be >= 1')
    end
end

if is_load_new_data
    time_course_file = dataset('XLSFile',char(time_course_file),'ReadObsNames',false);
    clustering_data_file = dataset('XLSFile',char(clustering_data_file),'ReadObsNames',false);
    genes_file = dataset('XLSFile',char(genes_file),'ReadObsNames',false);
    
    if ~exist('TF_file', 'var') || isempty(TF_file)
        TF = genes_file;
    else
        TF = dataset('XLSFile',char(TF_file),'ReadObsNames',false);
    end
    if ~exist('symbol_file', 'var') || isempty(symbol_file)
        tmp(:,1)=genes_file(:,1);
        tmp(:,2)=genes_file(:,1);
        symbol = tmp;
    else
        symbol = dataset('XLSFile',char(symbol_file),'ReadObsNames',false);
    end
    save('DATA_GENIST','time_course_file','clustering_data_file','genes_file','TF','symbol');
else
    load('DATA_GENIST','time_course_file','clustering_data_file','genes_file','TF','symbol');
end

temp_data = double(time_course_file(:,2:end));
clust_data = double(clustering_data_file(:,2:end));

ID_T = time_course_file(:,1); %Var that stores the IDs from the original files
ID_T = cellstr(ID_T);
ID_C = clustering_data_file(:,1); %Var that stores the IDs from the original files
ID_C = cellstr(ID_C);

genes = unique(genes_file(:,1));
genes = cellstr(genes);

%% Find  genes in the data
ID_T_pos = ismember(ID_T,genes); % Var that stores the position of the genes of interest in the time course dataset
pf_temp_data = temp_data(ID_T_pos,:); % prefiltered temporal data
ID_T = ID_T(ID_T_pos); % prefiltered IDs

ID_C_pos = ismember(ID_C,genes); % Var that stores the position of the genes of interest in the clustering dataset
pf_clust_data = clust_data(ID_C_pos,:); % prefiltered clustering data
ID_C = ID_C(ID_C_pos); % prefiltered IDs

% Sort genes
[genes] = sort(genes);
[ID_T,I] = sort(ID_T);
pf_temp_data = pf_temp_data(I,:); % sort temporal data
[ID_C,I] = sort(ID_C);
pf_clust_data = pf_clust_data(I,:); % sort clustering data

%% Cluster

% Normalization
M = mean(pf_clust_data,2); % % compute the mean of each expression pattern
S = std(pf_clust_data,0,2) + 1e-5; % compute the variance of each expression pattern
M_mat = M*ones(1,size(pf_clust_data,2));
S_mat = S*ones(1,size(pf_clust_data,2));
clust_data_norm = (pf_clust_data-M_mat)./S_mat; % unit var

% CLUSTERING: Cluster filtered data
%%
TF_vector = cellstr(TF);
TF_in_genes_pos = ismember(genes,TF_vector)'; % find positions of the TFs
TF_in_genes = genes(TF_in_genes_pos);

if length(TF_in_genes) <= 10
    n_clusters = 1;
else
    eva = evalclusters(clust_data_norm,'linkage','silhouette','distance','sqEuclidean','KList',floor(length(TF_in_genes)/10):floor(length(TF_in_genes)/5));
    n_clusters = eva.OptimalK;
end

if n_clusters > 1
    Z = linkage(clust_data_norm,'ward','euclidean');
    IDX = cluster(Z,'maxclust',n_clusters);
end

% Print genes organized by clusters
n_IDX = zeros(1,n_clusters);
if n_clusters > 1
    for i = 1:n_clusters
        n_IDX(i) = sum(IDX==i);
        genes_per_cluter(1:n_IDX(i),i) = genes(IDX == i);
    end
else
    genes_per_cluter = genes;
    n_IDX = length(genes);
end
%%
hubs_AGI = {}; % create an empty cell array to store the names of the hubs of each cluster.
my_AGI_clusters = {}; % create an empty cell array to store the names of all the genes in each cluster (all the genes that we are using, but ordered as they appear in each cluster)
final_network = zeros(length(my_AGI_clusters)); % create an empty matrix to store all the connections
pos_tracker = 1; % var to track how many genes we've gone through already after each iteration, so we can build big_network from the individial networks

%% Find the GRN for each cluster

for i = 1:n_clusters
    my_clust = genes_per_cluter(1:n_IDX(i),i);
    ind_pos = ismember(ID_T,my_clust,'rows');
    g_int_temp = pf_temp_data(ind_pos,:); % select identified genes from the longitudinal data
    
    % find the symbol of each locus to plot the graph %
    sym = cellstr(symbol); % Convert variable from dataset to cell array to operate easier
    my_symbols = ID_T(ind_pos);
    
    if n_IDX(i) > 1
        [discrete_temp,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels] = GRN_preprocessing2_0(g_int_temp,is_reg_fc_th,is_reg_time_percent,n_levels,my_clust);
        
        [gene_names, network, sign_network] = GRN_inference2_0(discrete_temp,ID_T,ind_pos,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels,time_lapse,is_low_conn);
    else
        gene_names = my_clust;
        network = 0;
        sign_network = 0;
    end
    my_AGI_clusters = [my_AGI_clusters;gene_names];
    final_network(pos_tracker:pos_tracker+n_IDX(i)-1,pos_tracker:pos_tracker+n_IDX(i)-1) = network;
    final_sign_network(pos_tracker:pos_tracker+n_IDX(i)-1,pos_tracker:pos_tracker+n_IDX(i)-1) = sign_network;
    
    bin_net = network ~= 0; % binary version of network
    n_conn = sum(bin_net'); %# of connections (out) of each gene
    n_conn_max = max(n_conn);
    cluster_hub = n_conn == n_conn_max; %define a cluster hub as the gene within the cluster with largest # of connections (in and out)
    cluster_hub_AGI = gene_names(cluster_hub); % create a cell array to store the name of the hub of the current cluster
    hubs_AGI = [hubs_AGI,cluster_hub_AGI']; % combine two cell arrays
    
    pos_tracker = pos_tracker + n_IDX(i);
    
end
%% Repeat the process to combine all the clusters through their hubs

if n_clusters > 1
    
    hubs_pos = ismember(ID_T,hubs_AGI,'rows');
    
    g_int_temp = pf_temp_data(hubs_pos,:); % select identified genes from the longitudinal data
    
    [discrete_temp,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels] = GRN_preprocessing2_0(g_int_temp,is_reg_fc_th,is_reg_time_percent,n_levels);
    
    [inter_clust_AGI, inter_clust_net, inter_sign_network] = GRN_inference2_0(discrete_temp,ID_T,hubs_pos,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels,time_lapse,is_low_conn); % find connections among cluster hubs
    
    % Combine everything in one big network
    pos_ind = zeros(length(inter_clust_AGI),1);
    for i = 1:length(inter_clust_AGI)
        hub_pos_i = ismember(my_AGI_clusters,inter_clust_AGI(i),'rows');
        pos_ind(i) = find(hub_pos_i);
    end
    aux_network = zeros(size(final_network));
    aux_sign_network = zeros(size(final_network));
    aux_network(pos_ind,pos_ind) = inter_clust_net;
    aux_sign_network(pos_ind,pos_ind) = inter_sign_network;
    final_network = final_network + aux_network;
    final_sign_network = final_sign_network + aux_sign_network;
    
    bin_big_net = final_network ~= 0;
    
    % Plot
    gene_names = my_AGI_clusters;
    sym = cellstr(symbol);
    for i = 1:length(gene_names)
        idx = ismember(sym(:,1),gene_names(i),'rows');
        new_name = sym(idx,2);
        if ~isempty(new_name)
            if length(new_name)>1
                aux = sym(idx,2);
                gene_names(i) = aux(1);
            else
                gene_names(i) = sym(idx,2);
            end
        end
    end
    
    bg1 = biograph(final_network,gene_names,'ShowWeights', 'off','EdgeFontSize',12,'NodeAutoSize','off');
        
    for i = 1:size(bg1.edges)
        if get(bg1.edges(i),'Weight') < 0
            set(bg1.edges(i),'LineColor',[1 0 0]);
        else
            set(bg1.edges(i),'LineColor',[0 0 0]);
        end
        weight = abs(get(bg1.edges(i),'Weight'));
        set(bg1.edges(i),'LineWidth',2*weight);
    end
    for i = 1:size(bg1.nodes)
        set(bg1.nodes(i),'FontSize',12)
        set(bg1.nodes(i),'size',[30,30])
        bg1.Nodes(i).Shape = 'circle';
        set(bg1.nodes(i),'Color',[0.71,0.8,1])
        set(bg1.nodes(i),'LineColor',[0,0,0])
    end
    view(bg1)
else
    gene_names = my_AGI_clusters;
    sym = cellstr(symbol);
    for i = 1:length(gene_names)
        idx = ismember(sym(:,1),gene_names(i),'rows');
        new_name = sym(idx,2);
        if ~isempty(new_name)
            if length(new_name)>1
                aux = sym(idx,2);
                gene_names(i) = aux(1);
            else
                gene_names(i) = sym(idx,2);
            end
        end
    end

end
% Convert the matrix that is storing the network into a
% cytoscape-compatible table. Save the table in a text file called
% cytoscape_table in the current directory.
matrix_to_cytoscape_table2_0(gene_names,final_network, final_sign_network);
end
