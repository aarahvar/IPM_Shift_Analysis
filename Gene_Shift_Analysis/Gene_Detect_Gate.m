%function Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Logic_Output)
current_path = pwd;
index = find(current_path=='\');
addpath([current_path(1:index(end)) 'Time_Series_Boolean'])
addpath(current_path(1:(index(end)-1)))

%Flag_1D = 0: shift_1 ~= shift_2 | 1: shift_1 = shift_2
Flag_1D = 0 ;
Manual_Flag = 1; %1:use manually digitized data

max_shift= 5;
Remove_percent = .05;
Display_Detection_Flag = 0;

Anti_Log = 0  ;
Use_Smoothed_Curve =0  ;
normalized_hill_flag = 0;
Normalize_Input_Flag = 1;
Use_Hill_Flag = 1;
Plot_Hill_Mesh_Flag = 0;


if ~exist('gene_names_std')
    load('DTA_data');
end

if ~isempty(which('Yeast_CellCycle.mat')) && ~exist('Yeast_CellCycle')
    load('Yeast_CellCycle.mat');
end

if ~exist('excel_cDTA')
    load('excel_cDTA');
end



TF1_name = 'fkh2';
TF2_name = 'ndd1';
T_name = 'clb2';


Num_Row = 13 ;

TF1_name = cell2mat(excel_cDTA.TF1(Num_Row));
TF2_name = cell2mat(excel_cDTA.TF2(Num_Row));
T_name = cell2mat(excel_cDTA.T(Num_Row));

% %
total_flag = 1;
ts_set_number = 2;

plot_ts_flag = 1;
windowSize = 4;
Range_divider_thr = 10;


timespan = 0:5:205;


if lower(TF1_name(1))=='y'
    TF1_name= Gene_Sysname_2_Stdname(TF1_name);
    TF2_name= Gene_Sysname_2_Stdname(TF2_name);
    T_name= Gene_Sysname_2_Stdname(T_name);
    if isempty(TF1_name) || isempty(TF2_name) || isempty(T_name) || strcmp(TF1_name,'no_sn')|| strcmp(TF2_name,'no_sn')|| strcmp(T_name,'no_sn')
        errordlg('No data!')
        return
    end
end

clc
for total_flag = [1 0]
    for ts_set_number = [1 2]
        
        if Manual_Flag == 0
            Gene_Index = geneStd2Num({TF1_name,TF2_name,T_name});
            
            if length(Gene_Index)==3
                m=0;
                for ii = Gene_Index(1:end-1)'
                    m=m+1;
                    
                    %eval like: TF(m).TF = expr1( ii,:)  (it could be expr1 or expr2)
                    if total_flag
                        eval(['TF(m).TF = expr' num2str(ts_set_number) '( ii,:);']);
                    else
                        eval(['TF(m).TF = syn' num2str(ts_set_number) '( ii,:);']);
                    end
                    TF(m).TF = TF(m).TF(1:end)';
                    
                    
                end
            end
            %Preprocess the time series of TFs (Anti-log and normalization)
            TF(1).TF = Preprocess_Timeseries(TF(1).TF,Anti_Log,Normalize_Input_Flag);
            TF(2).TF = Preprocess_Timeseries(TF(2).TF,Anti_Log,Normalize_Input_Flag);
            
            [TF_b,~]=Find_TF_Slop(TF,windowSize,Range_divider_thr,[],Use_Smoothed_Curve,...
                Anti_Log,plot_ts_flag,timespan,0,0);
            
            %Extract the time series of the measured target gene time
            if total_flag
                eval(['T = expr' num2str(ts_set_number) '( Gene_Index(end),:);']);
            else
                eval(['T = syn' num2str(ts_set_number) '( Gene_Index(end),:);']);
            end
            T = T(1:end)';
            T = T/max(T);
            
            %Discretize T_real_ts to identify the logic
            [T_d,~] = up_down_discretize(T,windowSize,Range_divider_thr,Use_Smoothed_Curve);
            T_b = (T_d==1)+0;
            T_b(isnan(T_d)) = NaN;
            
            if plot_ts_flag
                diff_t = diff(timespan);
                diff_t = diff_t(1);
                timespan_Tb = timespan(1):diff_t:(timespan(1)+length(T_b)-1)*diff_t;
                subplot(313)
                plot(timespan_Tb,T,'marker','.','markersize',10);
                hold on
                plot(timespan_Tb,T_b,'r','linewidth',2);
                ylim([0  1])
                xlim([timespan_Tb(1)  timespan_Tb(end)])
                ax(1) = subplot(311);
                ax(2) = subplot(312);
                ax(3) = subplot(313);
                linkaxes(ax,'x');
            end
            
        else
            
            if total_flag
                eval(['TF(1).TF = Yeast_CellCycle.' upper(TF1_name) '.expr' num2str(ts_set_number) ';' ]);
                eval(['TF(2).TF = Yeast_CellCycle.' upper(TF2_name) '.expr' num2str(ts_set_number) ';']);
                eval(['T = Yeast_CellCycle.' upper(T_name) '.expr' num2str(ts_set_number) ';']);
                
                eval(['TF_b(1).TF_b = Yeast_CellCycle.' upper(TF1_name) '.expr' num2str(ts_set_number) '_b;' ]);
                eval(['TF_b(2).TF_b = Yeast_CellCycle.' upper(TF2_name) '.expr' num2str(ts_set_number) '_b;']);
                eval(['T_b = Yeast_CellCycle.' upper(T_name) '.expr' num2str(ts_set_number) '_b;']);
            else
                eval(['TF(1).TF = Yeast_CellCycle.' upper(TF1_name) '.syn' num2str(ts_set_number) ';' ]);
                eval(['TF(2).TF = Yeast_CellCycle.' upper(TF2_name) '.syn' num2str(ts_set_number) ';']);
                eval(['T = Yeast_CellCycle.' upper(T_name) '.syn' num2str(ts_set_number) ';']);
                
                eval(['TF_b(1).TF_b = Yeast_CellCycle.' upper(TF1_name) '.syn' num2str(ts_set_number) '_b;' ]);
                eval(['TF_b(2).TF_b = Yeast_CellCycle.' upper(TF2_name) '.syn' num2str(ts_set_number) '_b;']);
                eval(['T_b = Yeast_CellCycle.' upper(T_name) '.syn' num2str(ts_set_number) '_b;']);
            end
            
            if plot_ts_flag
                Num_TF = 2;
                figure(10)
                clf
                for i=1:Num_TF
                    
                    subplot(Num_TF+1,1,i);
                    plot(timespan,[TF(i).TF],'marker','.','markersize',10)
                    hold on
                    plot(timespan,TF_b(i).TF_b,'linewidth',2);
                    eval(['ylabel(''TF_' num2str(i) ''')']);
                    xlim([timespan(1) timespan(end)]);
                    if i==1
                        title(['TF1: ' upper(TF1_name) ' , TF2: ' upper(TF2_name) ' , T: ' upper(T_name)])
                        
                    end
                end
                
                subplot(Num_TF+1,1,Num_TF+1);
                plot(timespan,T,'marker','.','markersize',10)
                hold on
                plot(timespan,T_b,'linewidth',2);
                xlim([timespan(1) timespan(end)]);
                
            end
        end
        
        
        
        %Calculate the entopies and the detect the gates
        [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift,Remove_Index,Sorted_Cnt_0_1]=Find_Gate_Entropy_Min(TF_b,T_b,max_shift,Remove_percent,Flag_1D);
        
        if Flag_1D
            Entropy_min = Sorted_Entropy(1);
            shift_min_1 = Sorted_Shift_Index(1);
            shift_min_2 = shift_min_1;
        else
            Entropy_min = Sorted_Entropy(1);
            shift_min_1 = Sorted_Shift_Index(1,1);
            shift_min_2 = Sorted_Shift_Index(1,2);
        end
        
        
        %Find the probability of 0 and 1 as the detected output for each input state
        [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_min_1,shift_min_2,[],0);
        
        %Calculate entropy
        %clc
        display(' ')
        if Flag_1D
            display('================ 1D ========================')
            display(['Shift = ' num2str(shift_min_1) ' , Entropy = ' num2str(Entropy_min,2)])
            figure(2)
            plot(0:max_shift,Entropy,'marker','o')
            title(['Shift = ' num2str(Sorted_Shift_Index(1,1)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])
            
        else
            display('================ 2D ========================')
            figure(2);
            surf(0:max_shift,0:max_shift,Entropy')
            title(['Shift_1 = ' num2str(Sorted_Shift_Index(1,1)) ' , Shift_2 = ' num2str(Sorted_Shift_Index(1,2)) ', Entropy = ' num2str(Sorted_Entropy(1),4) ' , Logic: ' num2str(Detected_Output_Over_Shift(1,:))])
            view(0,90);
        end
        
        display(' ')
        for i=1:length(Sorted_Shift_Index)
            if i<6 || sum(Sorted_Shift_Index(i,:))==0
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
                display([num2str(Sorted_Shift_Index(i,:),2) '   ||   ' str_neg  '   ||   ' num2str(Sorted_Entropy(i),2) ])
                
                %display([num2str(Sorted_Shift_Index(i,:),2) '   ||   ' num2str( Detected_Output_Over_Shift(i,:),2)  '   ||   ' num2str(Sorted_Entropy(i),2) '    [' num2str(Remove_Index(i).index',2) ']'])
                if i==5
                    display('_____________________________________________________________');
                end
            end
        end
    end
end





