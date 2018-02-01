function [AGI_names, network1, sign_network1] = GRN_inference2_0(discr_temp_data,AGI,ind_pos,reg,set_max_reg,change_t_up,change_t_down,n_genes,n_levels,time_lapse,is_low_conn)

% Calculate the probabilities that each potential regulator regulates its
% target

%% Calculate probabilities

% likelihood of each target gene given each subset of regulators
% The number of subsets of at most m elements in a set of n elements is
% n!/(m!(n-m)!). I subtract 1 because I don't want to account for the null
% subset. The first dimension is for the (max) number of possibilites for
% the genes to be repressors or activators.
% P(t|Eact) = P(t=1|E=1) + P(t=0|E=0) prob that E is an activator of t
% P(t|Erep) = P(t=0|E=1) + P(t=1|E=0) prob that E is a repressor of t
% This is what I store in L.

global symbol

BDe = -inf*ones(n_genes,2); 
ind_max = cell(set_max_reg,n_genes,2);
rep_act = zeros(14,n_genes,2);
sign = cell(set_max_reg,n_genes,2);

% individual conditional probabilities: P(t=1|E=1),P(t=1|E=0),P(t=0|E=1),P(t=0|E=0)
c_p = zeros(n_levels,n_levels,n_levels,n_levels); % #2 refers to 2 levels for each gene. The 4 dimensions refer to the fact that the maximum # of genes that I am comnining is 4 (3 reg + 1 target).
P_ab = zeros(n_levels,n_levels,n_levels,n_levels); % #2 refers to 2 levels for each gene. The 4 dimensions refer to the fact that the maximum # of genes that I am comnining is 4 (3 reg + 1 target).
ESS = 1e-15;%1e-4;%10;%1e-4;%5*n_levels; % Equivalent sample size

ind1 = sum(reg); % number of regulators & # of corregulators found for each gene
for i = 1:2  % this loop will calculate everything once for the regulators, and separately, a second time for the corregulators
    for j = 1:n_genes
        ind3 = find(reg(:,j,i));
        if ind1(1,j,i) > 0  % if var i has at least one regulator
            for k = ind1(1,j,i):-1:1 % for each regulator
                % Subset of regulators (all time points except for the last, because I need to align it with the target gene):
                E = discr_temp_data(ind3(k),1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                t = discr_temp_data(j,1+(-i+2):end)'; % Target gene (all time points except for the first, because I need to align it with the regulators):
               
                %Calculate conditional probabilities:
                BDei = 0;
                for r = 1:n_levels % # states of each target or regulator
                    Nj = E == r-1;
                    BDei = BDei + log(gamma(ESS/n_levels)/gamma(sum(Nj)+ESS/n_levels));
                    for d = 1:n_levels
                        Njk = E == r-1 & t == d-1;
                        BDei = BDei + log(gamma(sum(Njk)+ESS/(n_levels*n_levels))/gamma(ESS/(n_levels*n_levels)));
                    end
                end
                %BDei = BDei - (3*1/6)*log(T-(-i+2)); % penalty for complexity
                BDe(j,i) = max(BDe(j,i),BDei);
                if BDe(j,i) == BDei & BDei ~= -inf 
                    
                    % Calculate the sign of the regulation
                    E_change_up = change_t_up(ind3(k),1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                    E_change_down = change_t_down(ind3(k),1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                    t_change_up = change_t_up(j,1+(-i+2):end)'; % Target gene (all time points except for the first, because I need to align it with the regulators):
                    t_change_down = change_t_down(j,1+(-i+2):end)'; % Target gene (all time points except for the first, because I need to align it with the regulators):

%                     Neq = E == t;
                    Neq = (E_change_up == 1 & t_change_up == 1) | (E_change_down == 1 & t_change_down == 1);
%                     Nne = E ~= t;
                    Nne = (E_change_up == 1 & t_change_down == 1) | (E_change_down == 1 & t_change_up == 1);
                    for ind = 1:3
                        ind_max{ind,j,i} = [];
                    end
                    if sum(Neq) > sum(Nne)
                        ind_max{1,j,i} = ind3(k);
                        sign{1,j,i} = 1;
                    elseif sum(Neq) == sum(Nne)
                        ind_max{1,j,i} = ind3(k);
                        sign{1,j,i} = 0;
                    else
                        ind_max{1,j,i} = ind3(k);
                        sign{1,j,i} = -1; % Indicate the sign of the regulation in the index. Later change the sign to the value of the matrix in this index position
                    end
                end

                if ind1(1,j,i) > 1 & set_max_reg > 1
                    for kk = 1:k-1
                        E = discr_temp_data([ind3(k),ind3(kk)],1:end-(-i+2))';
                        
                        %Calculate conditional probabilities:
                        BDei = 0;
                        for r1 = 1:n_levels % # states of each target or regulator
                            for r2 = 1:n_levels
                                Nj = E(:,1) == r1-1 & E(:,2) == r2-1;
                                BDei = BDei + log(gamma(ESS/n_levels^2)/gamma(sum(Nj)+ESS/n_levels^2));% qi = n_levels^n_regulators
                                for d = 1:n_levels
                                    Njk = E(:,1) == r1-1 & E(:,2) == r2-1 & t == d-1;
                                    BDei = BDei + log(gamma(sum(Njk)+ESS/(n_levels*n_levels^2))/gamma(ESS/(n_levels*n_levels^2)));
                                end
                            end
                        end
                        %BDei = BDei - (6*1/6)*log(T-(-i+2)); % penalty for complexity
                        BDe(j,i) = max(BDe(j,i),BDei);
                        if BDe(j,i) == BDei & BDei ~= -inf
                            for ind = 1:3
                                ind_max{ind,j,i} = [];
                            end
                            ind_max{1,j,i} = ind3(k);
                            ind_max{2,j,i} = ind3(kk);
                            
                            % Calculate the sign of the regulation
                            E_change_up = change_t_up([ind3(k),ind3(kk)],1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                            E_change_down = change_t_down([ind3(k),ind3(kk)],1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                            for f = 1:2                                                               

                                Neq = (E_change_up(:,f) == 1 & t_change_up == 1) | (E_change_down(:,f) == 1 & t_change_down == 1);
                                Nne = (E_change_up(:,f) == 1 & t_change_down == 1) | (E_change_down(:,f) == 1 & t_change_up == 1);

                                if sum(Neq) > sum(Nne)
                                    sign{f,j,i} = 1;
                                elseif sum(Neq) == sum(Nne)
                                    sign{f,j,i} = 0;
                                else
                                    sign{f,j,i} = -1; % Indicate the sign of the regulation in the index. Later change the sign to the value of the matrix in this index position
                                end
                            end                           
                        end

                        if ind1(1,j,i) > 2 & set_max_reg > 2
                            for kkk = 1:kk-1
                                E = discr_temp_data([ind3(k),ind3(kk),ind3(kkk)],1:end-(-i+2))';
                                
                                %Calculate conditional probabilities:
                                BDei = 0;
                                for r1 = 1:n_levels % # states of each target or regulator
                                    for r2 = 1:n_levels
                                        for r3 = 1:n_levels
                                            Nj = E(:,1) == r1-1 & E(:,2) == r2-1 & E(:,3) == r3-1;
                                            BDei = BDei + log(gamma(ESS/n_levels^3)/gamma(sum(Nj)+ESS/n_levels^3));% qi = n_levels^n_regulators
                                            for d = 1:n_levels
                                                Njk = E(:,1) == r1-1 & E(:,2) == r2-1 & E(:,3) == r3-1 & t == d-1;
                                                BDei = BDei + log(gamma(sum(Njk)+ESS/(n_levels*n_levels^3))/gamma(ESS/(n_levels*n_levels^3)));
                                            end
                                        end
                                    end
                                end
                               % BDei = BDei - (11*1/6)*log(T-(-i+2)); % penalty for complexity
                                BDe(j,i) = max(BDe(j,i),BDei);
                                if BDe(j,i) == BDei & BDei ~= -inf
                                    for ind = 1:3
                                        ind_max{ind,j,i} = [];
                                    end
                                    ind_max{1,j,i} = ind3(k);
                                    ind_max{2,j,i} = ind3(kk);
                                    ind_max{3,j,i} = ind3(kkk);
                                     % Calculate the sign of the regulation
                                    E_change_up = change_t_up([ind3(k),ind3(kk),ind3(kkk)],1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                                    E_change_down = change_t_down([ind3(k),ind3(kk),ind3(kkk)],1:end-(-i+2))'; %(-i+2) is just to avoid an "if". when i==1, I want E to go from 1:end-1, and t to go from 2:end, but when i==2, i want both from 1:end. This (-i+2) solves the problem.
                                    for f = 1:3                                                               

                                        Neq = (E_change_up(:,f) == 1 & t_change_up == 1) | (E_change_down(:,f) == 1 & t_change_down == 1);
                                        Nne = (E_change_up(:,f) == 1 & t_change_down == 1) | (E_change_down(:,f) == 1 & t_change_up == 1);

                                        if sum(Neq) > sum(Nne)
                                            sign{f,j,i} = 1;
                                        elseif sum(Neq) == sum(Nne)
                                            sign{f,j,i} = 0;
                                        else
                                            sign{f,j,i} = -1; % Indicate the sign of the regulation in the index. Later change the sign to the value of the matrix in this index position
                                        end
                                    end
                                end
                            end
                        end                       
                    end
                end
            end
        end
    end
end

% Store the maximum of each conditional probability, which
% will indicate the final regulators and corregulators of each gene.
% 1 means activator; -1 means repressor. Each column indicates the
% regulator of 1 gene. 
network1 = zeros(n_genes,n_genes); 
network2 = zeros(n_genes,n_genes);
sign_network1 = zeros(n_genes,n_genes);
sign_network2 = zeros(n_genes,n_genes);

for i = 1:n_genes
    h1 = ind_max(:,i,1);
    s1 = sign(:,i,1);
    h2 = ind_max(:,i,2);
    s2 = sign(:,i,2);
    for j = 1:length(s1)  
        network1(abs(cell2mat(h1(j))),i) = 10^(BDe(i,1)); % Undo the logarithm to get positive values
        sign_network1(abs(cell2mat(h1(j))),i) = 1; 
        if cell2mat(s1(j)) < 0
            sign_network1(abs(cell2mat(h1(j))),i) = -1; 
        elseif cell2mat(s1(j)) == 0
            sign_network1(abs(cell2mat(h1(j))),i) = 0; 
        end
    end
    for j = 1:length(s2)       
        network2(abs(cell2mat(h2(j))),i) = 10^(BDe(i,2));
        sign_network2(abs(cell2mat(h2(j))),i) = 1; 
        if cell2mat(s2(j)) < 0
            sign_network2(abs(cell2mat(h2(j))),i) = -1; 
        elseif cell2mat(s2(j)) == 0
            sign_network2(abs(cell2mat(h2(j))),i) = 0; 
        end
   end
end

for i = 1:n_genes
    for j = 1:n_genes
        if network1(i,j) == -inf
            network1(i,j) = 0;
        end
        if network2(i,j) == -inf
            network2(i,j) = 0;
        end
    end
end

if time_lapse == 0
    network1 = network2; % if time_lapse == 0 --> continue operating with network 2, which is the one that has the corregulators stored
    sign_network1 = sign_network2;
elseif time_lapse == -1
    network1 = network1 + network2;
    sign_network1 = sign_network1 + sign_network2; % if an edge was predicted in both time_lapse with different signs, then the sum will be zero and the edge will have an undetermined sign 
    pos_idx = sign_network1 == 2;
    neg_idx = sign_network1 == -2;
    sign_network1(pos_idx) = 1;
    sign_network1(neg_idx) = -1;
else
    % if time_lapse == 1 --> continue operating with network 1, which is the one that has the regulators at t-1 stored. I actually don't need
    % to do anything bc the network that I pass to biograph is already called network1.
end

%Normalize values of the plotting network (relative to each other)

m1 = max(max(abs(network1)));
if m1 ~= 0
    network1 = network1/m1;
end

% Discard values that scored very low
nonzero_ind = abs(network1) > 0;
discard_ind = abs(network1) < is_low_conn*mean(mean(abs(network1(nonzero_ind))));
network1(discard_ind) = 0;

%% VISUALIZATION%%

sym = cellstr(symbol); 
my_AGI = AGI(ind_pos);
AGI_names = my_AGI;

for i = 1:length(my_AGI)
    idx = ismember(sym(:,1),my_AGI(i),'rows'); 
    new_name = sym(idx,2);
    if ~isempty(new_name)
        if length(new_name)>1
            aux = sym(idx,2);
            my_AGI(i) = aux(1);
        else
            my_AGI(i) = sym(idx,2);
        end
    end
end
my_AGI1 = my_AGI;


bg1 = biograph(network1,my_AGI1,'ShowWeights', 'off','EdgeFontSize',12,'NodeAutoSize','off');

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

 