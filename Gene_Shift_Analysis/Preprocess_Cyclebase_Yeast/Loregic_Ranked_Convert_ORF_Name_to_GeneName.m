Loregic_Tri_Sorted_Periodic_Rank_non_ORF = TF;
for i=2:size(TF,1)
    for j=1:1
        if geneStd2Num(TF{i,j})>0
            Loregic_Tri_Sorted_Periodic_Rank_non_ORF{i,j}= gene_names_sys(geneStd2Num(TF{i,j}));
        end
        
    end
end