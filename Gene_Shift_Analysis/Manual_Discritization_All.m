clc
current_path = pwd;
index = find(current_path=='\');
addpath([current_path(1:index(end)) 'Time_Series_Boolean'])
addpath(current_path(1:(index(end)-1)))

% if ~exist('ts_value_5min')
    load('Yeat_Cyclebase_5min');
% end

load('YGMD_2TF_T_Ranked.mat');
load('Manually_Processed_Index.mat')
load('Processed_Gene_Name.mat')
load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Preprocess_Cyclebase_Yeast\Gene_Names.mat')

Anti_Log = 0  ;
Use_Smoothed_Curve =0  ;
normalized_hill_flag = 0;
Normalize_Input_Flag = 1;
Use_Hill_Flag = 1;
Plot_Hill_Mesh_Flag = 0;

plot_ts_flag = 1;
windowSize = 2;
Range_divider_thr = 20;

for i = max(2,Manually_Processed_Index(1)):size(YGMD_2TF_T_Ranked,1)
    if Manually_Processed_Index(2)==3
        Manually_Processed_Index(2)=0;
    end
    for j = (Manually_Processed_Index(2)+1):3
        Gene_Name = YGMD_2TF_T_Ranked{i,j};
        Gene_Name = Gene_Name{1,1};
        
        %Change the name to ORF style
        if length(Gene_Name)<7 || Gene_Name(1)~='Y'
           Gene_Name =  upper(gene_names_sys(geneStd2Num(lower(Gene_Name))));
           Gene_Name = Gene_Name{1,1};
        end
        
        
        if ismember(Gene_Name,Processed_Gene_Name)
            continue;
        else
            Processed_Gene_Name{end+1}=Gene_Name;
        end
        
        %Check if the gene exists in the structure
        if ~isfield(ts_value_5min,upper(Gene_Name))
            continue;
        end
        
       
        Gene =getfield(ts_value_5min,Gene_Name);
        ts_Source_Name =fieldnames(Gene);
        
        for s = 1:length(ts_Source_Name)
            eval(['Gene_ts = Gene.' ts_Source_Name{s} '.ts;']);
            if isempty(Gene_ts)
                eval(['Gene.' ts_Source_Name{s} '.ts_b=[];']);
                continue;
            end
            
            timespan = 0:5:(length(Gene_ts)-1)*5;
            
            eval(['binary_exist = isfield(Gene.' ts_Source_Name{s} ',''ts_b'');'])
            
            if binary_exist
                eval(['binary_empty = isempty(Gene.' ts_Source_Name{s} '.ts_b);'])
            else
                binary_empty = 1;
            end
            if ~binary_empty
                eval(['Gene_ts_b = Gene.' ts_Source_Name{s} '.ts_b;']);
            else
                
                %Normalize input time-series
                Gene_ts = Preprocess_Timeseries(Gene_ts,Anti_Log,Normalize_Input_Flag);
                
                %Discitize timeseries
                Gene_ts_d = up_down_discretize(Gene_ts,windowSize,Range_divider_thr,Use_Smoothed_Curve);
                %Binary timeseries
                Gene_ts_b = (Gene_ts_d==1)+0;
                Gene_ts_b(isnan(Gene_ts_d)) = NaN;
                
            end
            
            %% Manuaaly modify binarization
            figure(5)
            clf
            
            plot(Gene_ts,'marker','.','markersize',10);hold on
            plot(Gene_ts_b/2+.25,'r','marker','o','markersize',5)
            xlim([0 length(Gene_ts_b)+1])
            title([ts_Source_Name{s} ' : ' upper(Gene_Name) ' (' cell2mat(YGMD_2TF_T_Ranked{i,j}) ')'])
            
            
            %Edit binary date
            button = 0;
            while 1
                [x,~,button] = ginput(1);
                if button == 27 %<Esc>
                    break;
                end
                
                if button == 113 %'q'
                    break;
                end
                
                if button == 120 %'x'
                    return;
                end
                
                x = round(x);
                
                Gene_ts_b(x) = ~Gene_ts_b(x);
                
                figure(5)
                clf
                
                plot(Gene_ts,'marker','.','markersize',10);hold on
                plot(Gene_ts_b/2+.25,'r','marker','o','markersize',5)
                xlim([0 length(Gene_ts_b)+1])
                title([ts_Source_Name{s} ' : ' upper(Gene_Name) ' (' cell2mat(YGMD_2TF_T_Ranked{i,j}) ')'])
                
            end
            
            if button == 113 %'q'
                eval(['ts_value_5min.' Gene_Name '.' ts_Source_Name{s} '.ts_b=[];']);
                Gene_ts = Gene_ts(:)';
                eval(['ts_value_5min.' Gene_Name '.' ts_Source_Name{s} '.ts=Gene_ts;']);
                save ('Yeat_Cyclebase_5min.mat','ts_value_5min');
                continue
            end
            
            
            Gene_ts_b = Gene_ts_b(:)';
            Gene_ts = Gene_ts(:)';
            
            
            
            eval(['ts_value_5min.' Gene_Name '.' ts_Source_Name{s} '.ts_b=Gene_ts_b;']);
            eval(['ts_value_5min.' Gene_Name '.' ts_Source_Name{s} '.ts=Gene_ts;']);
            
            save ('Yeat_Cyclebase_5min.mat','ts_value_5min');
            
        end
        Manually_Processed_Index = [i j];
        save('Manually_Processed_Index.mat','Manually_Processed_Index');
        save('Processed_Gene_Name.mat','Processed_Gene_Name');
    end
    
end

