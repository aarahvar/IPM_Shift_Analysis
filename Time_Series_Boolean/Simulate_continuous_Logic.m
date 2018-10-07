
timespan = 0:5:500;
shift_1 = 2 ;
shift_2 = 1;
Noise_Level = .7 ;
Logic_Output = [1 1 0 1];
plot_ts_flag = 1;


N_t = length(timespan);

TF(1).TF = sin(2*pi*timespan/(55)+(2*pi*.15*(rand(1,N_t)-.5)));
TF(2).TF = sin(2*pi*(timespan+randperm(59,1))/(60)+(2*pi*.15*(rand(1,N_t)-.5)));



n= 4   ;
tau = 5   ;


windowSize = 2;
Range_divider_thr = 10;
Num_TF = length(TF);



Anti_Log = 0  ;
Use_Smoothed_Curve =0  ;
normalized_hill_flag = 0;
Normalize_Input_Flag = 1;
Use_Hill_Flag = 1;
Plot_Hill_Mesh_Flag = 0;



Y0= .8*rand+.1;%T_real_ts(shift+1);

[TF_d,TF_s,TF_b,y_out] = Generate_Target_ts(TF,Logic_Output,Y0,timespan,windowSize,...
    Range_divider_thr,Use_Smoothed_Curve,Anti_Log,plot_ts_flag,Plot_Hill_Mesh_Flag,Use_Hill_Flag,...
    normalized_hill_flag,n,tau,Normalize_Input_Flag,shift_1,shift_2,Noise_Level);


%Discretize T_real_ts to identify the logic
[T_d,T_s] = up_discretize(y_out,windowSize,Range_divider_thr,Use_Smoothed_Curve);
T_b = (T_d==1)+0;
T_b(isnan(T_d)) = NaN;
%plot(timespan_Tb,T_s,'g','linewidth',2);
diff_t = diff(timespan);
diff_t = diff_t(1);
timespan_Tb = timespan(1):diff_t:(timespan(1)+length(T_b)-1)*diff_t;

if plot_ts_flag
    plot(timespan_Tb,T_b,'r','linewidth',2);
    ylim([0  1])
    ax(1) = subplot(311);
    ax(2) = subplot(312);
    ax(3) = subplot(313);
    linkaxes(ax,'x');
end



% clc
% %00
% ind = find(~TF_b(1).TF_b & ~TF_b(2).TF_b);
% count00=hist(T_b(ind'),[0 1]);
% display(['00: ' num2str(count00)]);
% %01
% ind = find(~TF_b(1).TF_b & TF_b(2).TF_b);
% count01=hist(T_b(ind'),[0 1]);
% display(['01: ' num2str(count01)]);
% 
% 
% %10
% ind = find(TF_b(1).TF_b & ~TF_b(2).TF_b);
% count10=hist(T_b(ind'),[0 1]);
% display(['10: ' num2str(count10)]);
% 
% 
% %11
% ind = find(TF_b(1).TF_b & TF_b(2).TF_b);
% count11=hist(T_b(ind'),[0 1]);
% display(['11: ' num2str(count11)]);
% 
% display('***************************')
% [~,out_11] = max(count11);
% out_11 = out_11-1;
% [~,out_10] = max(count10);
% out_10 = out_10-1;
% [~,out_01] = max(count01);
% out_01 = out_01-1;
% [~,out_00] = max(count00);
% out_00 = out_00-1;
% 
% 
% Logic_Output
% display(['00: ' num2str(out_00)]);
% display(['01: ' num2str(out_01)]);
% display(['10: ' num2str(out_10)]);
% display(['11: ' num2str(out_11)]);
