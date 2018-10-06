function [Discretized,ts_smoothes] = up_discretize(ts,windowSize,Range_divider_thr,Use_Smoothed_Curve)

ts=ts(:);
Num_NaN = sum(isnan(ts));
ts(1:Num_NaN)=[];

% Filter for smoothing
if Use_Smoothed_Curve
    b = (1/windowSize)*ones(1,windowSize);
    ts=[ones(windowSize,1)*ts(1);ts];
    ts_smoothes = filter(b,1,ts);
    ts_smoothes(1:windowSize)=[];
else
    ts_smoothes = ts;
end


range = max(ts-min(ts));
thr = range/Range_divider_thr;

%Find difference of consecutive samples
ts_diff = diff(ts_smoothes);

%Do not change the slope sign if the change is too small
no_change_index = find(abs(ts_diff)<thr);

%For the first sample, there is no previously detected slope to be replaced, hence we ignore the first sample
if (~isempty(no_change_index) && no_change_index(1)==1)
    no_change_index(1)=[];
end

%If the change is too smal, we continue the last detected sign (hence, the slope would be +/-1 (not zero)
for i=no_change_index'
    ts_diff(i) = ts_diff(i-1);
end

Discretized = sign(ts_diff);

Discretized = [Discretized(1);Discretized];

Discretized = [NaN(Num_NaN,1);Discretized];
ts_smoothes = [NaN(Num_NaN,1);ts_smoothes];
end
