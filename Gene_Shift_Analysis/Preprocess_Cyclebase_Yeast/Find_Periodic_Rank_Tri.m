%This function remove the tri-combinations that target gene is same as one of the TFs
% if ~exist('periodic_gene')
    load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
% end

Sum_periodic_Rank = zeros(length(Loregic_Tri)-1,3);
for i = 2:length(Loregic_Tri)
    for j = 1:3
        Gene_Index = find(strcmp(Loregic_Tri{i,j},periodic_gene));
        if ~isempty(Gene_Index)
            Sum_periodic_Rank(i-1,j) = peiodic_rank(Gene_Index);
        else
            Sum_periodic_Rank(i-1,j) = 1e6;
        end
    end
end

[Sorted_Tri_Periodeic_Rank,index] = sort(sum(Sum_periodic_Rank,2));

Loregic_Tri_Sorted_Periodic_Rank = Loregic_Tri;
Loregic_Tri_Sorted_Periodic_Rank(2:length(Loregic_Tri),:) = Loregic_Tri(index+1,:);

Sum_periodic_Rank = Sum_periodic_Rank(index,:);
