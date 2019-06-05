function fpkm_replicates(repfile,file2,sample2name)

Trep = readtable(char(repfile)); 
T2 = readtable(char(file2)); 

T2_FPKM = T2{:,{'FPKM'}};
T2_ID = T2{:,{'tracking_id'}};

[T_ID,i1rep,i2] = intersect(table2cell(Trep(:,1)),T2_ID) ;
TT_ID = table(T_ID,'VariableNames',{'tracking_id'});
TTrep = Trep(i1rep,2:end);
TT2 = table(T2_FPKM(i2), 'VariableNames', cellstr(sample2name));
T = [TT_ID TTrep TT2];

delete 'FPKM_replicates.xlsx'
writetable(T,'FPKM_replicates.xlsx','Sheet',1)

end

