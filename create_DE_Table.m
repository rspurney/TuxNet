function DETable = create_DE_Table(mk,n_genes,q_th,FC_th,filename)

% Creates a differential expression table according to the definition of
% enrichment provided by the user

% Author:
% M. Angels de Luis Balaguer
% Postdoctoral Research Scholar
% North Carolina State University
% 2016


n_cond = length(mk);
n_comp_vect = 1:n_cond-1;
n_comp = sum(n_comp_vect);

[~,expression,gene_ID,~,q] = create_Exp_Table(n_genes,n_cond,n_comp,mk,filename);

enr1 = zeros(n_genes,n_comp);
enr2 = zeros(n_genes,n_comp);
var_names1 = {};
var_names2 = {};
c = 0;

for i = 1:n_cond-1
    for j = i+1:n_cond
        c = c+1;
        enr1(:,c) = (log2(expression(:,i)./expression(:,j)) > FC_th & q(:,c) < q_th);
        enr2(:,c) = (log2(expression(:,j)./expression(:,i)) > FC_th & q(:,c) < q_th);
        var_names1(c) = strcat(mk(i),'_',mk(j));
        var_names2(c) = strcat(mk(j),'_',mk(i));
    end
end

DETable1 = array2table(enr1,'VariableNames',var_names1);
DETable2 = array2table(enr2,'VariableNames',var_names2);
ExpressionTable_name = table(gene_ID);
DETable = [ExpressionTable_name DETable1 DETable2]; % Expression values table

writetable(DETable,'data_DE','Delimiter','tab');
end