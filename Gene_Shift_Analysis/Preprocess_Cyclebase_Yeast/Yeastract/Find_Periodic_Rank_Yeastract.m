%This function remove the tri-combinations that target gene is same as one of the TFs
% if ~exist('periodic_gene')
    load('periodic_rank.mat');
% end

TF_Periodic_Rank = zeros(length(TF_Name)-1,1);
for i = 2:length(TF_Name)
        Gene_Index = find(strcmp(lower(TF_ORF_Name{i}),lower(periodic_gene)));
        if ~isempty(Gene_Index)
            TF_Periodic_Rank(i-1) = peiodic_rank(Gene_Index);
        else
            TF_Periodic_Rank(i-1) = 1e6;
        end
end

[Sorted_Tri_Periodeic_Rank,index] = sort(TF_Periodic_Rank);


TF_Sorted_Periodic_Rank(:,1) = TF_ORF_Name;
TF_Sorted_Periodic_Rank(:,2) = TF_Name;
for i=1:length(TF_Periodic_Rank)
    TF_Sorted_Periodic_Rank{i+1,3} = TF_Periodic_Rank(i);
end

TF_Sorted_Periodic_Rank(2:length(TF_Name),:) = TF_Sorted_Periodic_Rank(index+1,:);

