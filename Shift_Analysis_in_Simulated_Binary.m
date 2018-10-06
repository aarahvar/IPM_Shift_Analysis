if exist('definput.mat', 'file')~=2
    N= 10000 ;
    Shift_Generate = 2 ;
    %The shift used in data generation  T(t+shift) = f(TFs)
    
    %The shift used in gate detection
    shift_Detect = 3  ;
    
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

% definput = {'1000','2','2','.6','.4','0','0.05','[0 0 1 0]','0'}
% save('definput','definput');

prompt = {'N:','Shift generate:','Shift  detect:', 'p_1:','p_2:','Error rate:','Remove Percent','Logic_Output', 'Show result;'};
parameters = inputdlg(prompt,'Input',[1 35],definput);
if ~isempty(parameters)
    definput = parameters;
    save('definput','definput');
end


N = str2num(parameters{1});
Shift_Generate = str2num(parameters{2});
shift_Detect = str2num(parameters{3});
p_bionomial_1 = str2num(parameters{4});
p_bionomial_2 = str2num(parameters{5});
Error_Rate = str2num(parameters{6});
Remove_percent = str2num(parameters{7});
Logic_Output = str2num(parameters{8});
Display_Detection_Flag = str2num(parameters{9});

Entropy=[];
%Entropy = zeros(1,1000);
for i=1:1%1000
    %generate Bionomial variables for TF values
    TF_b = struct();
    TF_b(1).TF_b = binornd(1,p_bionomial_1,N,1);
    TF_b(2).TF_b = binornd(1,p_bionomial_2,N,1);
    
    %Generate the Target binary values
    T_b=  Calculate_Output_Logic(TF_b,Logic_Output,Shift_Generate);
    
    %Generate noise (invert Error_Rate% of T valuse)
    %The pest entropy of detection would the entropy of a bionomial with p = Error_Rate
    if Error_Rate ~= 0
        %Find the index of T values that should be inverted (randperm should be used to generate unique indexes)
        ind_error = randperm(N,floor(Error_Rate*N));
        T_b(ind_error) = ~T_b(ind_error);
        
    end
    
    %Find the probability of 0 and 1 as the detected output for each input state
    [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_Detect,Logic_Output,Display_Detection_Flag);
    
    
    Entropy(i) = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent);
    if Display_Detection_Flag
        Entropy
    end
end

if i~=1
    figure(1);hist(Entropy,75)
    title(['P_1 = ' num2str(p_bionomial_1) ' , P_2 = ' num2str(p_bionomial_2) ' , Error-Rate = ' num2str(Error_Rate)  ', d_g = ' num2str(Shift_Generate) ', d_d = ' num2str(shift_Detect)])
end