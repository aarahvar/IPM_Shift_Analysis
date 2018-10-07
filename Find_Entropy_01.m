function [Entropy,Remove_Index] = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent)

%We have some sources of erronous entropy (making small values of entropy):
%1) If an input state has not been observed (the corresponding row in Cnt_0_1 is [0 0]
%2) A state is observed rarely. In this case, if 0 or 1 is detected 0 times and the other
%is found rarely, it makes certainty (entropy = 0). In this case, if the non-zero counts
%is less than 5% (Remove_percent) of the total number of the samples, we do not consider this state in calculations
Remove_Index = ~(Cnt_0_1(:,1) & Cnt_0_1(:,2));
Sum_Cnt = sum(Cnt_0_1,2);
Remove_Index = Remove_Index & Sum_Cnt<(Remove_percent*sum(sum(Cnt_0_1)));
if sum(Remove_Index)~=0
    P_0_1(Remove_Index,: )=[];
    
    %We report thr index of the removed element to be considered in the results later
    Remove_Index = find(Remove_Index);
else
    Remove_Index=[];
end

%To calculate entropy, replace pr=0 with pr=1
P_0_1(P_0_1==0) = 1;

Entropy = mean(-P_0_1(:,1).*log2(P_0_1(:,1))-P_0_1(:,2).*log2(P_0_1(:,2)));


end