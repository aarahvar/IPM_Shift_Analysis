%This function remove the tri-combinations that target gene is same as one of the TFs
load('Gene_Names.mat')
Sum_periodic_Rank = zeros(length(YCRD)-1,3);
for i = 2:length(YCRD)
    for j = 1:2
        Gene_Index = find(strcmp(gene_names_sys(geneStd2Num(lower(YCRD{i,j}))),periodic_gene));
        if ~isempty(Gene_Index)
            Sum_periodic_Rank(i-1,j) = peiodic_rank(Gene_Index);
        else
            Sum_periodic_Rank(i-1,j) = 1e6;
        end
    end
end

[Sorted_Tri_Periodeic_Rank,index] = sort(sum(Sum_periodic_Rank,2));

Loregic_Tri_Sorted_Periodic_Rank = YCRD;
Loregic_Tri_Sorted_Periodic_Rank(2:length(YCRD),:) = YCRD(index+1,:);

Sum_periodic_Rank = Sum_periodic_Rank(index,:);
