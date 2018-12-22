%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
current_path = pwd;
index = find(current_path=='\');
addpath([current_path(1:index(end)) 'Time_Series_Boolean'])
addpath(current_path(1:(index(end)-1)))

%Flag_1D = 0: shift_1 ~= shift_2 | 1: shift_1 = shift_2
Flag_1D = 0 ;
Manual_Flag = 1; %1:use manually digitized data

max_shift= 5 ;
Remove_percent = 0.05;
Display_Detection_Flag = 0;

Anti_Log = 0  ;
Use_Smoothed_Curve =0  ;
normalized_hill_flag = 0;
Normalize_Input_Flag = 1;
Use_Hill_Flag = 1;
Plot_Hill_Mesh_Flag = 0;


if ~exist('ts_value_5min')
    load('Yeat_Cyclebase_5min');
end
load('YGMD_2TF_T_Ranked.mat');
load('YGMD_2TF_T_Ranked_ORF.mat');
load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Gene_Names.mat')
%load('C:\Users\Amiri\Desktop\IPM\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Gene_Names.mat')
%Get the name of the databases
Source_Name =fieldnames(ts_value_5min.YLR268W);

%============================================================================

%  Num_Row =4 ;

TF1_name = cell2mat(YGMD_2TF_T_Ranked_ORF{Num_Row,1});
TF2_name = cell2mat(YGMD_2TF_T_Ranked_ORF{Num_Row,2});
T_name = cell2mat(YGMD_2TF_T_Ranked_ORF{Num_Row,3});

% %Change the name to ORF style
% if length(TF1_name)<7 || TF1_name(1)~='Y'
%     TF1_name =  upper(gene_names_sys(geneStd2Num(lower(YGMD_2TF_T_Ranked{Num_Row,1}))));
%     TF1_name = TF1_name{1,1};
% end
% if length(TF2_name)<7 || TF2_name(1)~='Y'
%     TF2_name =  upper(gene_names_sys(geneStd2Num(lower(YGMD_2TF_T_Ranked{Num_Row,2}))));
%     TF2_name = TF2_name{1,1};
% end
% if length(T_name)<7 || T_name(1)~='Y'
%     T_name =  upper(gene_names_sys(geneStd2Num(lower(YGMD_2TF_T_Ranked{Num_Row,3}))));
%     T_name = T_name{1,1};
% end
% 

plot_ts_flag = 1;
windowSize = 2;
Range_divider_thr = 10;


timespan = 0:5:205;


TF1 =getfield(ts_value_5min,TF1_name);
TF2 =getfield(ts_value_5min,TF2_name);
T =getfield(ts_value_5min,T_name);


%% Merge all data in a vector to be displayed
ts_Total.TF1 = [];
ts_Total.TF1_b = [];
ts_Total.TF2 = [];
ts_Total.TF2_b = [];
ts_Total.T = [];
ts_Total.T_b = [];
for i = 1:length(Source_Name)
    source_name = cell2mat(Source_Name(i));
   
    if ~(isfield(TF1,source_name) && isfield(TF2,source_name) && isfield(T,source_name))
        continue
    end
    TF1_ts = getfield(TF1,source_name);
    TF2_ts = getfield(TF2,source_name);
    T_ts = getfield(T,source_name);
    
    if ~isempty(TF1_ts.ts) && ~isempty(TF2_ts.ts) && ~isempty(T_ts.ts) && (isfield(TF1_ts,'ts_b') && ~isempty(TF1_ts.ts_b)) && ...
            (isfield(TF2_ts,'ts_b') && ~isempty(TF2_ts.ts_b)) && (isfield(T_ts,'ts_b') && ~isempty(T_ts.ts_b))
        ts_Total.TF1 = [ts_Total.TF1 TF1_ts.ts NaN];
        ts_Total.TF1_b = [ts_Total.TF1_b TF1_ts.ts_b NaN];
        
        ts_Total.TF2 = [ts_Total.TF2 TF2_ts.ts NaN];
        ts_Total.TF2_b = [ts_Total.TF2_b TF2_ts.ts_b NaN];
        
        ts_Total.T = [ts_Total.T T_ts.ts NaN];
        ts_Total.T_b = [ts_Total.T_b T_ts.ts_b NaN];
        
    end
end

if isempty(ts_Total.TF1) || isempty(ts_Total.TF2) || isempty(ts_Total.TF2)
    errordlg('No Data!')
    return
end

if plot_ts_flag
    figure(10)
    clf
    
    subplot(3,1,1);
    plot(ts_Total.TF1,'marker','.','markersize',10)
    hold on
    plot(ts_Total.TF1_b,'linewidth',2);
    ylabel('TF_1')
    
    subplot(3,1,2);
    plot(ts_Total.TF2,'marker','.','markersize',10)
    hold on
    plot(ts_Total.TF2_b,'linewidth',2);
    ylabel('TF_2')
    
    subplot(3,1,3);
    plot(ts_Total.T,'marker','.','markersize',10)
    hold on
    plot(ts_Total.T_b,'linewidth',2);
    ylabel('T')
    
    
    ax(1) = subplot(311);
    ax(2) = subplot(312);
    ax(3) = subplot(313);
    linkaxes(ax,'x');
    
end

%%
clc
TF_b(1).TF_b = ts_Total.TF1_b;
TF_b(2).TF_b = ts_Total.TF2_b;

% %%%%%%%%%  SIMULATED DATA%%%%%%%%%%%%%%%%
% s1 = 3;
% s2=2;
% TF_b(1).TF_b = randi([0 1],1,300);
% TF_b(2).TF_b = randi([0 1],1,300);
% Tbb (4:203)=~TF_b(1).TF_b(1:200) & TF_b(2).TF_b(3:202);
% 
% Tbb = Tbb(4:203)+0;
% TF_b(1).TF_b = TF_b(1).TF_b(4:203);
% TF_b(2).TF_b = TF_b(2).TF_b(4:203);
% nanind = [10 50 80 120];
% TF_b(1).TF_b(nanind)=NaN;
% TF_b(2).TF_b(nanind)=NaN;
% Tbb(nanind)=NaN;
% ts_Total.T_b = Tbb;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the entopies and the detect the gates
[Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index,Sorted_Cnt_0_1]=Find_Gate_Entropy_Min(TF_b,ts_Total.T_b,max_shift,Remove_percent,Flag_1D);

if Flag_1D
    Entropy_min = Sorted_Entropy(1);
    shift_min_1 = Sorted_Shift_Index(1);
    shift_min_2 = shift_min_1;
else
    Entropy_min = Sorted_Entropy(1);
    shift_min_1 = Sorted_Shift_Index(1,1);
    shift_min_2 = Sorted_Shift_Index(1,2);
end



%Calculate entropy
%clc
TF1_name0 = cell2mat(YGMD_2TF_T_Ranked{Num_Row,1});
TF2_name0 = cell2mat(YGMD_2TF_T_Ranked{Num_Row,2});
T_name0 = cell2mat(YGMD_2TF_T_Ranked{Num_Row,3});

display(' ')
if Flag_1D
    display('================ 1D ========================')
    display(['Shift = ' num2str(shift_min_1) ' , Entropy = ' num2str(Entropy_min,2)])
    figure(2)
    plot(0:max_shift,Entropy,'marker','o')
    title(['Shift = ' num2str(Sorted_Shift_Index(1,1)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])
    
else
    display(['================ 2D (Num_Row =' num2str(Num_Row) ') ========================'])
    display(['********** ' TF1_name0 ' , ' TF2_name0 ' --> ' T_name0 ' **********'])
    figure(2);
    surf(0:max_shift,0:max_shift,Entropy')
    title(['Shift_1 = ' num2str(Sorted_Shift_Index(1,1)) ' , Shift_2 = ' num2str(Sorted_Shift_Index(1,2)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])
    view(0,90);
end

Gate_str = [{'0       '},{'AND     '},{'RF1*~RF2'},{'RF1     '} ,{'~RF1*RF2'},{'RF2     '},{'XOR     '},{'OR      '},{'NOR     '},{'XNOR    '},{'~RF2    '},{'RF1+~RF2'},{'~RF1    '},{'~RF1+RF2'},{'NAND    '},{'1       '}];
for i=1:length(Sorted_Shift_Index)
    if i<30 || sum(Sorted_Shift_Index(i,:))==0
        str_neg = [];
        for ii=1:length(Detected_Output_Over_Shift(i,:))
            if ismember(ii,Remove_Index(i).index)
                str_neg = [str_neg 'v'];
            elseif Detected_Output_Over_Shift(i,ii) == -1
                str_neg = [str_neg 'x'];
            else
                str_neg = [str_neg num2str(Detected_Output_Over_Shift(i,ii))];
            end
        end
        if isempty(str2num(str_neg))
            display([num2str(Sorted_Shift_Index(i,:),2) '   ||   ' str_neg  '   ||   ' '--------   ||   '  num2str(Sorted_Entropy(i),2) ])
        else
            display([num2str(Sorted_Shift_Index(i,:),2) '   ||   ' str_neg  '   ||   '  Gate_str{bi2de(str_neg=='1','left-msb')+1} '   ||   '  num2str(Sorted_Entropy(i),2) ])
        end

        
        %display([num2str(Sorted_Shift_Index(i,:),2) '   ||   ' num2str( Detected_Output_Over_Shift(i,:),2)  '   ||   ' num2str(Sorted_Entropy(i),2) '    [' num2str(Remove_Index(i).index',2) ']'])
        if i==5 
            display('_____________________________________________________________');
        end
    end
end






