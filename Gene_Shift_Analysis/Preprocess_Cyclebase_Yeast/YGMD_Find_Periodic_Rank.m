clear all
[~, ~, TFcops(2).TF] = xlsread('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\YGMD_Unique_TF_Pairs_Ranked.xls','TF(ORF)=2','H1:J774');
load('periodic_rank.mat')
load('Gene_Names.mat')
TFcops(2).TF(242:end,:)=[];
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
    xlswrite('2TF_T_YGMD_Ranked2',TFcops(n).TF,page_num,'A1');
    xlswrite('2TF_T_YGMD_Ranked2',sum(Sum_periodic_Rank,2),page_num,'D2');
    page_num = page_num+1;
    xlswrite('2TF_T_YGMD_Ranked2',TFcops(n).TF_Periodic_rank,page_num,'A1');
end

