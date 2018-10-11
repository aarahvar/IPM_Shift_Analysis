function y_out = Generate_Target_ts(TF,Logic_Output,Y0,timespan,plot_ts_flag,Plot_Hill_Mesh_Flag,...
    Use_Hill_Flag,normalized_hill_flag,n,tau,shift_1,shift_2,Noise_Level)

synthetic_term = Interpolate_Production_Term(Logic_Output,TF,Plot_Hill_Mesh_Flag,Use_Hill_Flag,normalized_hill_flag,n,shift_1,shift_2);


%Solve the ODE to generate the target gene time-series
nTime     = length(synthetic_term);
y_out    = zeros(nTime, length(Y0));
y_out(1, :) = Y0;
y0=Y0;
for iTime = 2:nTime-1
    [~, y_] = ode45(@(t,y) odefcn(y,tau, synthetic_term(iTime)), timespan(iTime-1:iTime), y0+Noise_Level*(rand(1)-.5));
    y0       = y_(end, :);
    y_out(iTime, :) = y0;
end

y_out = [NaN(max(shift_1,shift_2),1);y_out];

%Normalize the output
y_out = (y_out-min(y_out));
y_out = y_out/max(y_out);

if plot_ts_flag
    figure(10)
    hold on
    subplot(313)
    % plot(timespan(1:end-1),[T_real_ts(1:end-1)],'marker','.','markersize',10)
    diff_t = diff(timespan);
    diff_t = diff_t(1);
    timespan_Tb = timespan(1):diff_t:(timespan(1)+length(y_out)-1)*diff_t;
    
    plot(timespan_Tb,y_out,'marker','.','markersize',10)
    ylabel('T')
    xlim([timespan(1) timespan(end)]);
end

