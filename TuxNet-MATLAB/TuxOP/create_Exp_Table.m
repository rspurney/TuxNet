function [ExpressionTable,mk_i,gene_ID,qTable,q_resized] = create_Exp_Table(n_genes,n_cond,n_comp,mk,filename)

% Creates the following tables from the file returned by Cuffdiff:
% p_values: Table containing all the p values.
% q_values: Table containing all the q values.
% gene_expression: Table containing the expression of all genes in all conditions.
% complete_table: Table containing the expression of all genes in all conditions, the fold changes among conditions, p values, and q values.

% Author:
% M. Angels de Luis Balaguer
% Postdoctoral Research Scholar
% North Carolina State University
% 2016

T = readtable(char(filename),'Delimiter','tab');

c_names = table2cell(T(:,5:6)); % columns that contain the names of the conditions
ind_mk = zeros(size(T,1),n_cond); % matrix to store the indices of a set of rows of length n_genes that have all values for one zone

for i = 1:n_cond-1
    ind_mk(:,i) = ismember(c_names(:,1),mk(i)) & ismember(c_names(:,2),mk(i+1)) |...
        ismember(c_names(:,1),mk(i+1)) & ismember(c_names(:,2),mk(i));
    pos1 = logical(ind_mk(:,i));
    flag =  ismember(mk(i),c_names(pos1,1)); % if flag == 1 -> my current marker is in pos 8 of the table. if tag == 0, then it's in positition 9.
    pos2 = int8(9-flag); % pos = 8 or pos = 9
    mk_i(:,i) = table2array(T(pos1,pos2)); % create matrix with the expression values
    
end
ind_mk(:,end) = ismember(c_names(:,1),mk(end)) & ismember(c_names(:,2),mk(end-1)) |...
    ismember(c_names(:,1),mk(end-1)) & ismember(c_names(:,2),mk(end));
pos1 = logical(ind_mk(:,end));
flag =  ismember(mk(end),c_names(pos1,1));
pos2 = int8(9-flag);
mk_i(:,n_cond) = table2array(T(pos1,pos2));

gene_ID = table2cell(T(pos1,3));
ExpressionTable = array2table(mk_i,'VariableNames',mk);
ExpressionTable_name = table(gene_ID);
ExpressionTable = [ExpressionTable_name ExpressionTable]; % Expression values table

% Build a table of q values

p_values = table2array(T(:,12));
q_values = table2array(T(:,13));
fold_change = table2array(T(:,10));
c = 0;
q_var_names = {};
p_var_names = {};
fc_var_names = {};
p_resized = zeros(n_genes,n_comp);
q_resized = zeros(n_genes,n_comp);
fold_change_resized = zeros(n_genes,n_comp);

for i = 1:n_cond-1
    for j = i+1:n_cond
        c = c+1;
        ind_mk(:,c) = ismember(c_names(:,1),mk(i)) & ismember(c_names(:,2),mk(j)) |...
            ismember(c_names(:,1),mk(j)) & ismember(c_names(:,2),mk(i));
        q_var_names(c) = strcat('q',mk(i),'_',mk(j));
        p_var_names(c) = strcat('p',mk(i),'_',mk(j));
        p_resized(:,c) = p_values(logical(ind_mk(:,c)));
        q_resized(:,c) = q_values(logical(ind_mk(:,c)));
        
        fc_var_names(c) = strcat('log2fc_',mk(i),'_',mk(j));
        fold_change_resized(:,c) = fold_change(logical(ind_mk(:,c)));
    end
end
qTable = array2table(q_resized,'VariableNames',q_var_names);
fcTable = array2table(fold_change_resized,'VariableNames',fc_var_names);

CompleteTable = [ExpressionTable fcTable qTable]; % Table with all the values

writetable(ExpressionTable,'gene_expression.xlsx','Sheet',1);
writetable(CompleteTable,'complete_table.xlsx','Sheet',1);
end