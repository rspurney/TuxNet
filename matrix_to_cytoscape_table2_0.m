function matrix_to_cytoscape_table2_0(symbols,network,sign_network)

n_genes = size(network,1);
source = {};
target = {};
c = 0;

for i = 1:n_genes
    if sum(abs(network(i,:))) + abs(sum(network(:,i))) == 0
        c = c+1;
        source = [source; symbols(i)];
        target = [target; symbols(i)];
        edge(c) = 0;
        signs(c) = 1;
    end
    for j = 1:n_genes
        if network(i,j) ~= 0
            c = c+1;
            source = [source; symbols(i)];
            target = [target; symbols(j)];
            edge(c) = abs(network(i,j));
            signs(c) = sign_network(i,j);
        end
    end
end
width = edge';
sign = signs';
T = table(source,target,width,sign);
writetable(T,'cytoscape_table','Delimiter','tab');
