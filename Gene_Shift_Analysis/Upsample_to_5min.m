if ~exist('periodic_gene')
    load('C:\Users\Amir\MATLAB\Shift_Analysis\Gene_Shift_Analysis\Yeat_Cyclebase.mat');
end


for i=1:length(ts_value)
    source_name = ts_source{i};
    source_name(strfind(source_name,'-'))='_';
    gene_name = ts_gene{i};
    gene_name(strfind(gene_name,'-'))='_';
    
    if strcmp(source_name,'de Lichtenberg_cdc15')
        continue;
        
    elseif strcmp(source_name,'Spellman_alpha')
        if strfind(ts_value{i},'NA')
            %There are some samples that we have a missed point. we ignore them
            eval(['ts_value_5min.' gene_name '.' source_name '.ts=[];'] )
            continue;
        end
        %Convert 7min sampling to 5min
        ts = str2num(ts_value{i});
        t = 0:7:((length(ts)-1)*7);
        tq = 0:5:t(end);
        
        eval(['ts_value_5min.' gene_name '.' source_name '.ts=interp1(t,ts,tq);'] )
        
    elseif strcmp(ts_source{i},'Cho_cdc28') || strcmp(ts_source{1},'Spellman_cdc15')
        %Convert 10min sampling to 5min
        ts = str2num(ts_value{i});
        t = 0:10:((length(ts)-1)*10);
        tq = 0:5:t(end);
        
        eval(['ts_value_5min.' gene_name '.' source_name '.ts=interp1(t,ts,tq);'] )
    else
        %Sampling time is 5min itself
        ts = str2num(ts_value{i});
        eval(['ts_value_5min.' gene_name '.' source_name '.ts=ts;'] )
        
        
    end
end

%% Process cDTA Yeast data
if ~exist('gene_names_std')
    load('DTA_data');
end

for i=1:length(ts_value)
    source_name = 'cDTA';
    gene_name = ts_gene{i};
    gene_name(strfind(gene_name,'-'))='_';
    
    Gene_Index = geneSys2Num({gene_name});
    if Gene_Index == -1
        eval(['ts_value_5min.' gene_name '.cDTA_1.ts=[];'] )
        eval(['ts_value_5min.' gene_name '.cDTA_2.ts=[];'] )
        continue;
    end
    
    %Sampling time is 5min itself
    ts1 = expr1(Gene_Index,:);
    ts2 = expr2(Gene_Index,:);
    ts1 = (ts1-min(ts1))/(max(ts1)-min(ts1));
    ts2 = (ts2-min(ts2))/(max(ts2)-min(ts2));
    eval(['ts_value_5min.' gene_name '.cDTA_1.ts=ts1;'] )
    eval(['ts_value_5min.' gene_name '.cDTA_2.ts=ts2;'] )
    
    
end


