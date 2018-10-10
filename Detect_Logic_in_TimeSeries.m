function [Detection_Count_in_State,Detection_Probability_in_State] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_1,shift_2,Logic_Output,Display_Detection_Flag)

[~,Max_Indx] = max([shift_1 shift_2]);
Diff_shift = abs(shift_1-shift_2);
if Max_Indx ==1
    TF_bb(1).TF_b = TF_b(1).TF_b(1:end-Diff_shift);
    TF_bb(2).TF_b = TF_b(2).TF_b(1+Diff_shift:end);
    Shift_Max = shift_1;
elseif Max_Indx==2
    TF_bb(1).TF_b = TF_b(1).TF_b(1+Diff_shift:end);
    TF_bb(2).TF_b = TF_b(2).TF_b(1:end-Diff_shift);
    Shift_Max = shift_2;
end


N = length(T_b);
Num_TF = length(TF_bb);
Num_State = 2^Num_TF;
Detection_Probability_in_State = zeros(Num_State,2);
Detection_Count_in_State = zeros(Num_State,2);



% 00
ind = find(~TF_bb(1).TF_b & ~TF_bb(2).TF_b);
ind((Shift_Max+ind)> N)=[];

count00=hist(T_b(Shift_Max+ind'),[0 1]);
Detection_Probability_in_State(1,:) = count00/sum(count00);
Detection_Count_in_State(1,:) = count00;

if Display_Detection_Flag
    display(['00: ' num2str(count00)]);
end

%% 01
ind = find(~TF_bb(1).TF_b & TF_bb(2).TF_b);
ind((Shift_Max+ind)> N)=[];
count01=hist(T_b(Shift_Max+ind'),[0 1]);
Detection_Probability_in_State(2,:) = count01/sum(count01);
Detection_Count_in_State(2,:) = count01;

if Display_Detection_Flag
    display(['01: ' num2str(count01)]);
end


%% 10
ind = find(TF_bb(1).TF_b & ~TF_bb(2).TF_b);
ind((Shift_Max+ind)> N)=[];
count10=hist(T_b(Shift_Max+ind'),[0 1]);
Detection_Probability_in_State(3,:) = count10/sum(count10);
Detection_Count_in_State(3,:) = count10;

if Display_Detection_Flag
    display(['10: ' num2str(count10)]);
end


%11
ind = find(TF_bb(1).TF_b & TF_bb(2).TF_b);
ind((Shift_Max+ind)> N)=[];
count11=hist(T_b(Shift_Max+ind'),[0 1]);
Detection_Probability_in_State(4,:) = count11/sum(count11);
Detection_Count_in_State(4,:) = count11;

if Display_Detection_Flag
    display(['11: ' num2str(count11)]);
end


if Display_Detection_Flag
    clc

    display('***************************')
    
    
    [~,out_11] = max(count11);
    out_11 = out_11-1;
    [~,out_10] = max(count10);
    out_10 = out_10-1;
    [~,out_01] = max(count01);
    out_01 = out_01-1;
    [~,out_00] = max(count00);
    out_00 = out_00-1;
    
    
    Logic_Output
    display(['00: ' num2str(out_00)]);
    display(['01: ' num2str(out_01)]);
    display(['10: ' num2str(out_10)]);
    display(['11: ' num2str(out_11)]);
end
