%This function remove the tri-combinations that target gene is same as one of the TFs
if ~exist('periodic_gene')
    load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
end

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

Loregic_Tri(Remove_index,:)=[];