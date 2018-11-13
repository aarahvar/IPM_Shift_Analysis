%This function remove the tri-combinations that target gene is same as one of the TFs
% if ~exist('periodic_gene')
% load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
% end
    load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
Loregic_Tri = Loregic_Tri_Sorted_Periodic_Rank;
Remove_index = [];
for i = 2:length(Loregic_Tri)
    for j = 1:2
        for k=j+1:3
            if strcmp(Loregic_Tri{i,j},Loregic_Tri{i,k})
                Remove_index(end+1) = i;
                continue;
            end
        end
    end
end


%Some two consecutive row are same as each other and just the order of the inputs are reverse
for i = 2:length(Loregic_Tri)-1
    if strcmp(Loregic_Tri{i,1},Loregic_Tri{i+1,2}) && strcmp(Loregic_Tri{i,2},Loregic_Tri{i+1,1}) && ...
            strcmp(Loregic_Tri{i,3},Loregic_Tri{i+1,3})
        Remove_index(end+1) = i+1;
        continue;
    end
  
end

Loregic_Tri(unique(Remove_index),:)=[];
Loregic_Tri_Sorted_Periodic_Rank = Loregic_Tri;