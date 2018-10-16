clc
current_path = pwd;
index = find(current_path=='\');
addpath([current_path(1:index(end)) 'Time_Series_Boolean'])
addpath(current_path(1:(index(end)-1)))

if ~exist('gene_names_std')
    load('DTA_data');
end

if ~isempty(which('Yeast_CellCycle.mat')) && ~exist('Yeast_CellCycle')
    load('Yeast_CellCycle.mat');
end

Gene_Name = 'YDR310C';

if lower(Gene_Name(1))=='y'
    Gene_Name= Gene_Sysname_2_Stdname(Gene_Name);
    if isempty(Gene_Name) || strcmp(Gene_Name,'no_sn')
        errordlg('No data!')
        return
    end
end


Anti_Log = 0  ;
Use_Smoothed_Curve =0  ;
normalized_hill_flag = 0;
Normalize_Input_Flag = 1;
Use_Hill_Flag = 1;
Plot_Hill_Mesh_Flag = 0;




total_flag = 0;
ts_set_number = 2;

plot_ts_flag = 1;
windowSize = 4;
Range_divider_thr = 10;


timespan = 0:5:205;


if exist('Yeast_CellCycle') && isfield(Yeast_CellCycle,upper(Gene_Name))
    %If this gene is processed before, we load the modified gene
    eval(['Gene.expr1 = Yeast_CellCycle.' upper(Gene_Name) '.expr1;']);
    eval(['Gene.expr2 = Yeast_CellCycle.' upper(Gene_Name) '.expr2;']);
    eval(['Gene.syn1 = Yeast_CellCycle.' upper(Gene_Name) '.syn1;']);
    eval(['Gene.syn2 = Yeast_CellCycle.' upper(Gene_Name) '.syn2;']);
    
    eval(['expr1_b = Yeast_CellCycle.' upper(Gene_Name) '.expr1_b;']);
    eval(['expr2_b = Yeast_CellCycle.' upper(Gene_Name) '.expr2_b;']);
    eval(['syn1_b = Yeast_CellCycle.' upper(Gene_Name) '.syn1_b;']);
    eval(['syn2_b = Yeast_CellCycle.' upper(Gene_Name) '.syn2_b;']);
    
else
    Gene_Index = geneStd2Num({lower(Gene_Name)});
    if Gene_Index == -1
        errordlg('No data!')
        return
    end
    
    Gene.expr1 = expr1( Gene_Index,:);
    Gene.expr2 = expr2( Gene_Index,:);
    Gene.syn1 = syn1( Gene_Index,:);
    Gene.syn2 = syn2( Gene_Index,:);
    
    Gene.expr1 = Preprocess_Timeseries(Gene.expr1,Anti_Log,Normalize_Input_Flag);
    Gene.expr2 = Preprocess_Timeseries(Gene.expr2,Anti_Log,Normalize_Input_Flag);
    Gene.syn1  = Preprocess_Timeseries(Gene.syn1,Anti_Log,Normalize_Input_Flag);
    Gene.syn2  = Preprocess_Timeseries(Gene.syn2,Anti_Log,Normalize_Input_Flag);
    
    expr1_d = up_down_discretize(Gene.expr1,windowSize,Range_divider_thr,Use_Smoothed_Curve);
    expr1_b = (expr1_d==1)+0;
    expr1_b(isnan(expr1_d)) = NaN;
    
    expr2_d = up_down_discretize(Gene.expr2,windowSize,Range_divider_thr,Use_Smoothed_Curve);
    expr2_b = (expr2_d==1)+0;
    expr2_b(isnan(expr2_d)) = NaN;
    
    syn1_d = up_down_discretize(Gene.syn1,windowSize,Range_divider_thr,Use_Smoothed_Curve);
    syn1_b = (syn1_d==1)+0;
    syn1_b(isnan(syn1_d)) = NaN;
    
    syn2_d = up_down_discretize(Gene.syn2,windowSize,Range_divider_thr,Use_Smoothed_Curve);
    syn2_b = (syn2_d==1)+0;
    syn2_b(isnan(syn2_d)) = NaN;
end

%%
figure(5)
clf

subplot(221)
plot(Gene.expr1,'marker','.','markersize',10);hold on
plot(expr1_b/2+.25,'r','marker','o','markersize',5)
xlim([0 length(expr1_b)+1])
title([upper(Gene_Name)  '  (expr1)'])

subplot(222)
plot(Gene.expr2,'marker','.','markersize',10);hold on
plot(expr2_b/2+.25,'r','marker','o','markersize',5)
xlim([0 length(expr2_b)+1])
title([upper(Gene_Name) '  (expr2)'])

subplot(223)
plot(Gene.syn1,'marker','.','markersize',10);hold on
plot(syn1_b/2+.25,'r','marker','o','markersize',5)
xlim([0 length(syn1_b)+1])
title([upper(Gene_Name) '  (syn1)'])

subplot(224)
plot(Gene.syn2,'marker','.','markersize',10);hold on
plot(syn2_b/2+.25,'r','marker','o','markersize',5)
xlim([0 length(syn2_b)+1])
title([upper(Gene_Name) '  (syn2)'])

for k = 1:4
    subplot(2,2,k)
    set(gca,'tag',num2str(k))
end

%Edit binary date
button = 0;
while 1
    [x,~,button] = ginput(1);
    if button == 27 %<Esc>
        break
    end
    
    if button == 113 %'q'
        return
    end
    x = round(x);
    
    subplot_tag = get(gca,'tag');
    
    switch subplot_tag
        case '1' %1 subplot(221)
            expr1_b(x) = ~expr1_b(x);
        case '2' %2 subplot(222)
            expr2_b(x) = ~expr2_b(x);
        case '3' %3 subplot(223)
            syn1_b(x) = ~syn1_b(x);
        case '4' %4 subplot(224)
            syn2_b(x) = ~syn2_b(x);
    end
    
    figure(5)
    clf
    
    subplot(221)
    plot(Gene.expr1,'marker','.','markersize',10);hold on
    plot(expr1_b/2+.25,'r','marker','o','markersize',5)
    xlim([0 length(expr1_b)+1])
    title([upper(Gene_Name)  '  (expr1)'])
    
    subplot(222)
    plot(Gene.expr2,'marker','.','markersize',10);hold on
    plot(expr2_b/2+.25,'r','marker','o','markersize',5)
    xlim([0 length(expr2_b)+1])
    title([upper(Gene_Name) '  (expr2)'])
    
    subplot(223)
    plot(Gene.syn1,'marker','.','markersize',10);hold on
    plot(syn1_b/2+.25,'r','marker','o','markersize',5)
    xlim([0 length(syn1_b)+1])
    title([upper(Gene_Name) '  (syn1)'])
    
    subplot(224)
    plot(Gene.syn2,'marker','.','markersize',10);hold on
    plot(syn2_b/2+.25,'r','marker','o','markersize',5)
    xlim([0 length(syn2_b)+1])
    title([upper(Gene_Name) '  (syn2)'])
    
    for k = 1:4
        subplot(2,2,k)
        set(gca,'tag',num2str(k))
    end
    
end

expr1_b = expr1_b';
expr2_b = expr2_b';
syn1_b = syn1_b';
syn2_b = syn2_b';

eval(['Yeast_CellCycle.' upper(Gene_Name) '.expr1= Gene.expr1;']);
eval(['Yeast_CellCycle.' upper(Gene_Name) '.expr1_b= expr1_b;']);

eval(['Yeast_CellCycle.' upper(Gene_Name) '.expr2= Gene.expr2;']);
eval(['Yeast_CellCycle.' upper(Gene_Name) '.expr2_b= expr2_b;']);

eval(['Yeast_CellCycle.' upper(Gene_Name) '.syn1= Gene.syn1;']);
eval(['Yeast_CellCycle.' upper(Gene_Name) '.syn1_b= syn1_b;']);

eval(['Yeast_CellCycle.' upper(Gene_Name) '.syn2= Gene.syn2;']);
eval(['Yeast_CellCycle.' upper(Gene_Name) '.syn2_b= syn2_b;']);

save ('Yeast_CellCycle.mat')