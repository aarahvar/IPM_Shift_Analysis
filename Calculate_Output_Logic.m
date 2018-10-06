function T=  Calculate_Output_Logic(TF_b,Logic_Output,shift)

Num_TF = length(TF_b);
N_b = length(TF_b(1).TF_b);

%% Calculate the logical operation between the time series

b = dec2bin([0:length(Logic_Output)- 1])=='1';

T = zeros(N_b,1);

for indx = find(Logic_Output)
    sub_T = ones(N_b,1);
    for j=1:Num_TF
        if b(indx,j)==1
            sub_T = sub_T & TF_b(j).TF_b;
        else
            sub_T = sub_T & ~TF_b(j).TF_b;
        end
    end
    T = T | sub_T;
    
    
end
T=[zeros(shift,1);T(1:end-shift)];

end
