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

    title([cell2mat(YGMD_2TF_T_Ranked{Num_Row,1}) ' , ' cell2mat(YGMD_2TF_T_Ranked{Num_Row,2}) ' \rightarrow ' cell2mat(YGMD_2TF_T_Ranked{Num_Row,3})])
   
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



