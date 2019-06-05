function [discrete_temp_data,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels] = GRN_preprocessing2_0(temp_data,is_reg_fc_th,is_reg_time_percent,n_levels,genes)

    % Estimate potential regulators

    % Assumption:
    % The only genes that can regulate another gene are the ones that have a
    % change in the PREVIOUS or simultaneous time point. 

    
    global TF
    if nargin == 5
        TF_vector = cellstr(TF); % Convert the dataset into a cell of arrays type
        TF_in_genes_pos = ismember(genes,TF_vector)'; % find genes enriched in the cell type of interest    
    end
    
    
    T = size(temp_data,2);
    n_genes = size(temp_data,1);

    change_t = zeros(size(temp_data)); %positions where there is a significant fold change 

    for i = 2:T
        change_t(:,i) = (temp_data(:,i) > is_reg_fc_th*temp_data(:,i-1)) | (temp_data(:,i) < (1/is_reg_fc_th)*temp_data(:,i-1));
        change_t_up(:,i) = (temp_data(:,i) > 1.1*temp_data(:,i-1)); % Used to calculate the sign of rhe regulation
        change_t_down(:,i) = (temp_data(:,i) < 0.8*temp_data(:,i-1));
    end

     % variable to store potential regulators and corregulators. Contains two 
     % 2-D matrices. Each mat: columns correspond to variables, so column i
     % contains all the (co)regulators of gene i. First mat stores regulators.
     % Second mat stores corregulators.
    reg = zeros(n_genes,n_genes,2);

    for i = 1:n_genes
        for j = 2:T
            if change_t(i,j) == 1 
                reg(:,i,1) = reg(:,i,1) == 1 | change_t(:,j-1) == 1; %store potential regulators
                reg(:,i,2) = reg(:,i,2) == 1 | change_t(:,j) == 1; %store potential coregulators
            end
        end
    end

    if nargin == 5
        reg(~TF_in_genes_pos,:,:) = 0;
    end
    
    % remove diagonal from reg matrix. i.e., dont let genes autoregulate
    for i = 1:2
        D = diag(reg(:,:,i));
        reg(:,:,i) = reg(:,:,i) - diag(D);
    end

    for i = 1:n_genes
        for j = 1:n_genes
            scores(i,j,1) = sum(change_t(i,2:end) == change_t(j,1:end-1));
            scores(i,j,2) = sum(change_t(i,1:end) == change_t(j,1:end));
            if scores (i,j,1) < is_reg_time_percent*T % filter out the regulators that don't have a change in expression in at least a p% of the time course points
                reg(j,i,1) = 0;
            end
            if scores (i,j,2) < is_reg_time_percent*T % filter out the regulators that don't have a change in expression in at least a p% of the time course points
                reg(j,i,2) = 0;
            end
        end
    end
        

    %% Discretize original expression data in n_levels levels

    if n_levels == 2
        m = mean(temp_data,2) * ones(1,T);
        discrete_temp_data = temp_data >= m;
    else
    q = quantile(temp_data,n_levels-1,2); % quantile(X,N,dim)
    for i = 1:T
        for j = 1:n_genes
            if temp_data(j,i) < q(j,1)
                discrete_temp_data(j,i) = 0;
            end
            for k = 2:n_levels-1
                if temp_data(j,i) > q(j,k-1) & temp_data(j,i) < q(j,k)
                    discrete_temp_data(j,i) = k-1;
                end
            end
            if temp_data(j,i) > q(j,k)
                discrete_temp_data(j,i) = k;
            end
        end
    end
    end


    max_reg = max(max(sum(reg)));% max # of potential regulators that have been found for one gene
    if max_reg > 3
        set_max_reg = 3; % maximum number of possible regulators of a gene is set to 3.
    else
        set_max_reg = max_reg; 
    end

end