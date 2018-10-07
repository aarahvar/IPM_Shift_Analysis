%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
addpath([pwd '\Time_Series_Boolean'])

%Flag_1D = 0: shift_1 ~= shift_2 | 1: shift_1 = shift_2
Flag_1D = 0 ;

% Simulate_continuous_Logic;
max_shift= 5;
Display_Detection_Flag = 0;
Remove_percent = .05;

Sorted_Entropy = [];
Sorted_Shift_Index=[];
Detected_Output_Over_Shift = [];

if Flag_1D
    [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift]=Find_Entropy_Single_Shift(max_shift,TF_b,T_b,Remove_percent);
    Entropy_min = Sorted_Entropy(1);
    shift_min_1 = Sorted_Shift_Index(1);
    shift_min_2 = shift_min_1;
else
    [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift]=Find_Entropy_Double_Shift(max_shift,TF_b,T_b,Remove_percent);
    Entropy_min = Sorted_Entropy(1);
    shift_min_1 = Sorted_Shift_Index(1,1);
    shift_min_2 = Sorted_Shift_Index(1,2);
end


%Find the probability of 0 and 1 as the detected output for each input state
[Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_min_1,shift_min_2,Logic_Output,1);

%Calculate entropy
display(' ')
if Flag_1D
display('================ 1D ========================')
display(['Shift = ' num2str(shift_min) ' , Entropy = ' num2str(Entropy_min,2)])
figure(2)
plot(0:max_shift,Entropy,'marker','o')
title(['Shift = ' num2str(Sorted_Shift_Index(1,1)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])

else
display('================ 2D ========================')
figure(2);
surf(0:max_shift,0:max_shift,Entropy')
title(['Shift_1 = ' num2str(Sorted_Shift_Index(1,1)) ' , Shift_2 = ' num2str(Sorted_Shift_Index(1,2)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])
view(0,90);    
end

display(' ')
display(num2str([Sorted_Shift_Index Detected_Output_Over_Shift Sorted_Entropy],2))





