function fpkm_replicates_init(file1, file2, sample1name, sample2name)

T1 = readtable(char(file1)); 
T2 = readtable(char(file2)); 

T1_FPKM = T1{:,{'FPKM'}};
T2_FPKM = T2{:,{'FPKM'}};

T1_ID = T1{:,{'tracking_id'}};
T2_ID = T2{:,{'tracking_id'}};

[T_ID,i1,i2] = intersect(T1_ID,T2_ID) ;
TT_ID = table(T_ID,'VariableNames', {'tracking_id'});
TT1 = table(T1_FPKM(i1), 'VariableNames', cellstr(sample1name));
TT2 = table(T2_FPKM(i2), 'VariableNames', cellstr(sample2name));
T = [TT_ID TT1 TT2];

writetable(T,'FPKM_replicates.xlsx','Sheet',1)

end