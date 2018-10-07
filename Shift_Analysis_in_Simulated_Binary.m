if exist('definput.mat', 'file')~=2
    N= 10000 ;
    Shift_Generate_1 = 2 ;
    Shift_Generate_2 = 2 ;
    %The shift used in data generation  T(t+shift) = f(TFs)
    
    %The shift used in gate detection
    shift_Detect_1 = 3  ;
    shift_Detect_2 = 3  ;
    
    Display_Detection_Flag = 0;
    
    %The existing logic between TFs (00,01,10,11)
    Logic_Output = [0 0 1 0];
    
    %The probability of 1 for TF1 and TF (Bionomial)
    p_bionomial_1 = .5 ;
    p_bionomial_2 = 0.4 ;
    
    %The error rate that changes the valuse in the T values
    Error_Rate = 0.05;
    
else
    load('definput');
end

% definput = {'1000','2','2','2','2','.6','.4','0','0.05','[0 0 1 0]','0'}
% save('definput','definput');

prompt = {'N:','Shift generate 1:','Shift generate 2:','Shift  detect 1:','Shift  detect 2:', 'p_1:','p_2:','Error rate:','Remove Percent','Logic_Output', 'Show result;'};
parameters = inputdlg(prompt,'Input',[1 35],definput);
if ~isempty(parameters)
    definput = parameters;
    save('definput','definput');
end


N = str2num(parameters{1});
Shift_Generate_1 = str2num(parameters{2});
Shift_Generate_2 = str2num(parameters{3});
shift_Detect_1 = str2num(parameters{4});
shift_Detect_2 = str2num(parameters{5});
p_bionomial_1 = str2num(parameters{6});
p_bionomial_2 = str2num(parameters{7});
Error_Rate = str2num(parameters{8});
Remove_percent = str2num(parameters{9});
Logic_Output = str2num(parameters{10});
Display_Detection_Flag = str2num(parameters{11});

Shift_Generate_Max = max(Shift_Generate_1,Shift_Generate_2);
Entropy=[];
%Entropy = zeros(1,1000);
for i=1:1%1000
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
    
    %Find the probability of 0 and 1 as the detected output for each input state
    [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_Detect_1,shift_Detect_2,Logic_Output,Display_Detection_Flag);
    
    
    Entropy(i) = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent);
    if Display_Detection_Flag
        Entropy
    end
end

if i~=1
    figure(1);hist(Entropy,75)
    title(['P_1 = ' num2str(p_bionomial_1) ' , P_2 = ' num2str(p_bionomial_2) ' , Error-Rate = ' num2str(Error_Rate)  ', d_g = ' num2str(Shift_Generate) ', d_d = ' num2str(shift_Detect)])
end