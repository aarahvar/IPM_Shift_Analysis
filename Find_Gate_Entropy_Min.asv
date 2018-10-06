%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
addpath([pwd '\Time_Series_Boolean'])

Simulate_continuous_Logic;
max_shift= 6;
Display_Detection_Flag = 0;
Remove_percent = .05;

Entropy = zeros(1,max_shift);
Detected_Output_Over_Shift = zeros(max_shift+1,4);
for shift_Detect = 0:max_shift
    %Find the probability of 0 and 1 as the detected output for each input state
    [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_Detect,[],0);
       
    %Calculate entropy    
    Entropy(shift_Detect+1) = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent);
    
    [~,max_indx] =  max(Cnt_0_1');
    Detected_Output_Over_Shift(shift_Detect+1,:)=max_indx-1;
end

[Entropy_min, shift_min] = min(Entropy);
shift_min = shift_min-1;

%Find the probability of 0 and 1 as the detected output for each input state
[Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_min,Logic_Output,1);

%Calculate entropy
display(' ')
display(' ')
display(['Shift = ' num2str(shift_min) ' , Entropy = ' num2str(Entropy_min,2)])
figure(2)
plot(0:max_shift,Entropy)
title(['Logic:  ' num2str(Detected_Output_Over_Shift(shift_min+1,:))  '   ,  \delta = ' num2str(shift_min)])

[Sorted_Entropy,Sorted_Entropy_indx] = sort(Entropy);
shift_indx = (0:max_shift)';
display(' ')
display(num2str([shift_indx(Sorted_Entropy_indx) Detected_Output_Over_Shift(Sorted_Entropy_indx,:) Sorted_Entropy'],2))

