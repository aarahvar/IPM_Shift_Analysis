function  [TF_b,TF_s]=Find_TF_Slop(TF,windowSize,Range_divider_thr,Logic_Output,Use_Smoothed_Curve,...
    Anti_Log,plot_flag,timespan,shift_1,shift_2)

Num_TF = length(TF);


for i=1:length(TF)
    [TF_d(i).TF_d,TF_s(i).TF_s] = up_discretize(TF(i).TF,windowSize,Range_divider_thr,Use_Smoothed_Curve);
    
    if Use_Smoothed_Curve
        TF(i).TF = TF_s(i).TF_s;
        TF(i).TF = TF(i).TF/max(TF(i).TF);
    end
    if Anti_Log
        TF_d(i).TF_d=(TF_d(i).TF_d+1)/2;
    end
    
    TF_b(i).TF_b = (TF_d(i).TF_d==1);
    
end


if plot_flag
    figure(10)
    clf
    for i=1:Num_TF
        
        subplot(Num_TF+1,1,i);
        plot(timespan,[TF(i).TF],'marker','.','markersize',10)
        hold on
        plot(timespan,[(TF_d(i).TF_d+1)/2],'linewidth',2);
        eval(['ylabel(''TF_' num2str(i) ''')']);
        xlim([timespan(1) timespan(end)]);
        if i==1
            title(['Logic:  ' num2str(Logic_Output)])
            title(['Shift_1 = ' num2str(shift_1) ' , Shift_2 = ' num2str(shift_2) ' , Logic: ' num2str(Logic_Output)])

        end
    end
    
    subplot(Num_TF+1,1,Num_TF+1);
    hold on
    xlim([timespan(1) timespan(end)]);
    
end
