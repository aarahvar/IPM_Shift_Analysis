function [TF_b,T_b]= Simulate_Binary_ts(N,Shift_Generate_1,Shift_Generate_2,p_bionomial_1,p_bionomial_2,Error_Rate,Logic_Output)

Shift_Generate_Max = max(Shift_Generate_1,Shift_Generate_2);
%generate Bionomial variables for TF values
TF_b = struct();
TF_b(1).TF_b = binornd(1,p_bionomial_1,N,1);
TF_b(2).TF_b = binornd(1,p_bionomial_2,N,1);

%Generate the Target binary values
T_b=  Calculate_Output_Logic(TF_b,Logic_Output,Shift_Generate_1,Shift_Generate_2);

%Generate noise (invert Error_Rate% of T valuse)
%The pest entropy of detection would the entropy of a bionomial with p = Error_Rate
if Error_Rate ~= 0
    %Find the index of T values that should be inverted (randperm should be used to generate unique indexes)
    error_index = randperm(length(T_b)-Shift_Generate_Max,floor(Error_Rate*(length(T_b)-Shift_Generate_Max)));
    T_b(error_index+Shift_Generate_Max) = ~T_b(error_index+Shift_Generate_Max);
    
end



