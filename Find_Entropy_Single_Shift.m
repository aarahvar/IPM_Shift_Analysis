function [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift]=Find_Entropy_Single_Shift(max_shift,TF_b,T_b,Remove_percent)

Entropy = zeros(1,max_shift);
Detected_Output_Over_Shift = zeros(max_shift+1,4);
for shift_Detect = 0:max_shift
    %Find the probability of 0 and 1 as the detected output for each input state
    [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_Detect,shift_Detect,[],0);
    
    %Calculate entropy
    Entropy(shift_Detect+1) = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent);
    
    [~,max_indx] =  max(Cnt_0_1');
    Detected_Output_Over_Shift(shift_Detect+1,:)=max_indx-1;
end
[Sorted_Entropy,Sorted_Entropy_indx] = sort(Entropy);
Sorted_Shift_Index = (0:max_shift)';
Sorted_Shift_Index = Sorted_Shift_Index(Sorted_Entropy_indx);

Detected_Output_Over_Shift = Detected_Output_Over_Shift(Sorted_Entropy_indx,:);
Sorted_Entropy = Sorted_Entropy(:);
end