function [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index]=Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Flag_1D)
%This functions calculates the entropy and detects the corresponding gate of different values of shifts in two cases of shift1=shift2 and different
%values of shift_1 and shift_2. At the end it returns the sorted entropy and all other corresponding values
if Flag_1D
    [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index]=Find_Entropy_Single_Shift(max_shift,TF_b,T_b,Remove_percent);
else
    [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index]=Find_Entropy_Double_Shift(max_shift,TF_b,T_b,Remove_percent);
end

