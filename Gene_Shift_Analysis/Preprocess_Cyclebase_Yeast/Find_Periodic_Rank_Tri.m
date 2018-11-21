% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%    COMMENTED IS FOR LOREGIC
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %This function remove the tri-combinations that target gene is same as one of the TFs
% % if ~exist('periodic_gene')
%     load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
% % end
%
% Sum_periodic_Rank = zeros(length(Loregic_Tri)-1,3);
% for i = 2:length(Loregic_Tri)
%     for j = 1:3
%         Gene_Index = find(strcmp(Loregic_Tri{i,j},periodic_gene));
%         if ~isempty(Gene_Index)
%             Sum_periodic_Rank(i-1,j) = peiodic_rank(Gene_Index);
%         else
%             Sum_periodic_Rank(i-1,j) = 1e6;
%         end
%     end
% end
%
% [Sorted_Tri_Periodeic_Rank,index] = sort(sum(Sum_periodic_Rank,2));
%
% Loregic_Tri_Sorted_Periodic_Rank = Loregic_Tri;
% Loregic_Tri_Sorted_Periodic_Rank(2:length(Loregic_Tri),:) = Loregic_Tri(index+1,:);
%
% Sum_periodic_Rank = Sum_periodic_Rank(index,:);



% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%    COMMENTED IS FOR YGMD (Only TFs)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% 
% %This function remove the tri-combinations that target gene is same as one of the TFs
% clear all
% [~, ~, TFcops(2).TF] = xlsread('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Unique_TF_Pairs_YGMD.xls','2');
% [~, ~, TFcops(3).TF] = xlsread('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Unique_TF_Pairs_YGMD.xls','3');
% load('periodic_rank.mat')
% load('Gene_Names.mat')
% 
% page_num = 0;
% for n=2:3
%     Sum_periodic_Rank = zeros(size(TFcops(n).TF,1)-1,n);
%     for i = 2:size(TFcops(n).TF,1)
%         for j = 1:n
%             if geneStd2Num(TFcops(n).TF(i,j))==-1
%                 Gene_Index = [];
%             else
%                 Gene_Index = find(strcmp(lower(gene_names_sys(geneStd2Num(TFcops(n).TF(i,j)))),lower(periodic_gene)));
%             end
%             if ~isempty(Gene_Index)
%                 Sum_periodic_Rank(i-1,j) = peiodic_rank(Gene_Index);
%             else
%                 Sum_periodic_Rank(i-1,j) = 1e6;
%             end
%         end
%     end
%     
%     [Sorted_Tri_Periodeic_Rank,index] = sort(sum(Sum_periodic_Rank,2));
%     
%     TFcops(n).TF_Name_ranked = TFcops(n).TF;
%     TFcops(n).TF_Name_ranked(2:size(TFcops(n).TF,1),:) = TFcops(n).TF(index+1,:);
%     
%     TFcops(n).TF_Periodic_rank(2:size(TFcops(n).TF,1),:) = Sum_periodic_Rank(index,:);
%     
%     page_num = page_num+1;
%     xlswrite('Unique_TF_Pairs_YGMD_Ranked',TFcops(n).TF_Name_ranked,page_num,'A1');
%     page_num = page_num+1;
%     xlswrite('Unique_TF_Pairs_YGMD_Ranked',TFcops(n).TF_Periodic_rank,page_num,'A1');
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%    FOR YGMD (TFs + Targets)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%This function remove the tri-combinations that target gene is same as one of the TFs
clear all
[~, ~, TFcops(2).TF] = xlsread('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Unique_TF_Pairs_YGMD_Ranked.xls','TF=2','H1:J774');
load('periodic_rank.mat')
load('Gene_Names.mat')
TFcops(2).TF(289:end,:)=[];
page_num = 0;
for n=2%:3
    Sum_periodic_Rank = zeros(size(TFcops(n).TF,1)-1,n);
    for i = 2:size(TFcops(n).TF,1)
        if isnan(cell2mat(TFcops(n).TF(i,1)))
            continue
        end
        for j = 1:n+1
            if geneStd2Num(TFcops(n).TF(i,j))==-1
                Gene_Index = find(strcmp(lower(((TFcops(n).TF(i,j)))),lower(periodic_gene)));
            else
                Gene_Index = find(strcmp(lower(gene_names_sys(geneStd2Num(TFcops(n).TF(i,j)))),lower(periodic_gene)));
            end
            if ~isempty(Gene_Index)
                Sum_periodic_Rank(i-1,j) = peiodic_rank(Gene_Index);
            else
                Sum_periodic_Rank(i-1,j) = 1e6;
            end
        end
    end
    
    [Sorted_Tri_Periodeic_Rank,index] = sort(sum(Sum_periodic_Rank,2));
    
    TFcops(n).TF_Name_ranked = TFcops(n).TF;
    TFcops(n).TF_Name_ranked(2:size(TFcops(n).TF,1),:) = TFcops(n).TF(index+1,:);
    
    TFcops(n).TF_Periodic_rank(2:size(TFcops(n).TF,1),:) = Sum_periodic_Rank(index,:);
    
    page_num = page_num+1;
    xlswrite('2TF_T_YGMD_Ranked',TFcops(n).TF_Name_ranked,page_num,'A1');
    page_num = page_num+1;
    xlswrite('2TF_T_YGMD_Ranked',TFcops(n).TF_Periodic_rank,page_num,'A1');
end

