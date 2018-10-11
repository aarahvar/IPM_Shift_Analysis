function ts = Preprocess_Timeseries(ts,Anti_Log,Normalize_Input_Flag)

if Anti_Log
    ts=2.^ts;
end

if Normalize_Input_Flag %Nomalize beteen [0 1]
    ts = (ts-min(ts))/(max(ts)-min(ts));
else %Only normal maximum to one
    ts = ts/max(ts);
end
end
