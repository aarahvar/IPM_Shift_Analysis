%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
addpath([pwd '\Time_Series_Boolean'])

%Flag_1D = 0: shift_1 ~= shift_2 | 1: shift_1 = shift_2
Flag_1D = 0 ;
Binary_Simulation = 0;

max_shift= 5;
Remove_percent = .05;
Display_Detection_Flag = 0;
Logic_Output = [0 1 1 1];

Shift_Generate_1 = 2 ;
Shift_Generate_2 = 3 ;

N = 100;

if Binary_Simulation
    Error_Rate = .15;
    p_bionomial_1 = .6 ;
    p_bionomial_2 = .4 ;
    
    
    [TF_b,T_b]= Simulate_Binary_ts(N,Shift_Generate_1,Shift_Generate_2,p_bionomial_1,p_bionomial_2,Error_Rate,Logic_Output);
    
else
    timespan = 0:5:(N-1)*5;
    Noise_Level_Target = .7 ;
    plot_ts_flag = 1;
    n= 4   ;
    tau = 5   ;
    windowSize = 2;
    Range_divider_thr = 10;
    
    [TF_b,T_b]= Simulate_continuous_Logic(timespan,Shift_Generate_1,Shift_Generate_2,Noise_Level_Target,Logic_Output,plot_ts_flag,n,tau,windowSize,Range_divider_thr);
    
end

%Calculate the entopies and the detect the gates
[Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index]=Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Flag_1D);

if Flag_1D
    Entropy_min = Sorted_Entropy(1);
    shift_min_1 = Sorted_Shift_Index(1);
    shift_min_2 = shift_min_1;
else
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
    display(['Shift = ' num2str(shift_min_1) ' , Entropy = ' num2str(Entropy_min,2)])
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
for i=1:length(Sorted_Shift_Index)
    display([num2str([Sorted_Shift_Index(i,:) Detected_Output_Over_Shift(i,:) Sorted_Entropy(i) ],2) '    [' num2str(Remove_Index(i).index',2) ']'])
end





