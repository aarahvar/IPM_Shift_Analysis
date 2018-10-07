function T_b=  Calculate_Output_Logic(TF_b,Logic_Output,shift_1,shift_2)

Num_TF = length(TF_b);
N_b = length(TF_b(1).TF_b);
b = dec2bin([0:length(Logic_Output)- 1])=='1';

%% Calculate the logical operation between the time series

[~,Max_Indx] = max([shift_1 shift_2]);
Diff_shift = abs(shift_1-shift_2);
if Max_Indx ==1
    TF_bb(1).TF_b = TF_b(1).TF_b(1:end-Diff_shift);
    TF_bb(2).TF_b = TF_b(2).TF_b(1+Diff_shift:end);
elseif Max_Indx==2
    TF_bb(1).TF_b = TF_b(1).TF_b(1+Diff_shift:end);
    TF_bb(2).TF_b = TF_b(2).TF_b(1:end-Diff_shift);
end

T_b = zeros(N_b-Diff_shift,1);

for indx = find(Logic_Output)
    sub_T = ones(N_b-Diff_shift,1);
    for j=1:Num_TF
        if b(indx,j)==1
            sub_T = sub_T & TF_bb(j).TF_b;
        else
            sub_T = sub_T & ~TF_bb(j).TF_b;
        end
    end
    T_b = T_b | sub_T;
    
end

T_b = [NaN(max(shift_1,shift_2),1);T_b];

end
