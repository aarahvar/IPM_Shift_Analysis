%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
addpath([pwd '\Time_Series_Boolean'])
clear all
%Flag_1D = 0: shift_1 ~= shift_2 | 1: shift_1 = shift_2
Flag_1D = 0 ;
Binary_Simulation = 1;

max_shift= 5;
Remove_percent = .05;
Display_Detection_Flag = 0;
Logic_Output = [1 1 0 1];
Logic_Output_decimal = bi2de(Logic_Output,'left-msb');

Shift_Generate_1 = 2 ;
Shift_Generate_2 = 3 ;

N_vec = [10:10:90 100:100:1000];
Max_Iter = 10000;

Entropy_min = [];
shift_min_1 = [];
shift_min_2 = [];
Error_rate=[];

clc


for Error_Rate_Binary = .05:.05:.5;
    
    parfor n = 1:length(N_vec)
        N = N_vec(n);
        display(N)
        for iter = 1:Max_Iter
            
            %Choose an arbitrary logic
            Logic_Output_All = de2bi(1:14,'left-msb');
            Logic_Output = Logic_Output_All(randperm(size(Logic_Output_All,1),1),:);
            
            Sorted_Entropy = [];
            while isempty(Sorted_Entropy)
                if Binary_Simulation
                    
                    p_bionomial_1 = .6 ;
                    p_bionomial_2 = .4 ;
                    
                    
                    [TF_b,T_b]= Simulate_Binary_ts(N,Shift_Generate_1,Shift_Generate_2,p_bionomial_1,p_bionomial_2,Error_Rate_Binary,Logic_Output);
                    
                else
                    timespan = 0:5:(N-1)*5;
                    Noise_Level_Target = .7 ;
                    plot_ts_flag = 0;
                    n_hill= 4   ;
                    tau = 5   ;
                    windowSize = 2;
                    Range_divider_thr = 10;
                    
                    [TF_b,T_b]= Simulate_continuous_Logic(timespan,Shift_Generate_1,Shift_Generate_2,Noise_Level_Target,Logic_Output,plot_ts_flag,n_hill,tau,windowSize,Range_divider_thr);
                    
                end
                
                %Calculate the entopies and the detect the gates
                [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index]=Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Flag_1D);
            end
            if Flag_1D
                Entropy_min(iter,n) = Sorted_Entropy(1);
                shift_min_1(iter,n) = Sorted_Shift_Index(1);
                shift_min_2(iter,n) = Sorted_Shift_Index(1);
                Gate_decimal = bi2de(Detected_Output_Over_Shift,'left-msb');
            else
                Entropy_min(iter,n) = Sorted_Entropy(1);
                shift_min_1(iter,n) = Sorted_Shift_Index(1,1);
                shift_min_2(iter,n) = Sorted_Shift_Index(1,2);
                Gate_decimal = bi2de(Detected_Output_Over_Shift,'left-msb');
                
                %             Error_rate(iter,n) = (Logic_Output_decimal ~= Gate_decimal(1))
                
                Num_top_selection = 4;
                Detection_rate1(iter,n) = ismember(Logic_Output_decimal,Gate_decimal(1:min(size(Gate_decimal,1),1)));
%                 Detection_rate2(iter,n) = ismember(Logic_Output_decimal,Gate_decimal(1:min(size(Gate_decimal,1),2)));
%                 Detection_rate3(iter,n) = ismember(Logic_Output_decimal,Gate_decimal(1:min(size(Gate_decimal,1),3)));
%                 Detection_rate4(iter,n) = ismember(Logic_Output_decimal,Gate_decimal(1:min(size(Gate_decimal,1),4)));
%                 Detection_rate5(iter,n) = ismember(Logic_Output_decimal,Gate_decimal(1:min(size(Gate_decimal,1),5)));
                
                
            end
            
        end
    end
    
    figure(20);hold on
    semilogx(N_vec,mean(Detection_rate1))
    pause(1)
end
%legend('top-1','top-2','top-3','top-4','top-5')
title(['Gate detection rate (top-rank selection)'])
xlabel('#Sample')
ylabel('Gate detection rate')

beep
return





figure(20);clf
boxplot(Entropy_min,N_vec)
hold on
plot(median(Entropy_min),'DisplayName','Entropy_min')




