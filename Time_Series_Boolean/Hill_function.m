function Hill_Out = Hill_function(x,n,k,up_down,normalized_flag)
%Calculate the Hill fuction for up- and down-regulation
%The result can be normalized to set the output between 0 and 1

if strcmp(up_down,'up')
    Hill_Out = x.^n./(x.^n+k^n);
elseif  strcmp(up_down,'down')
    Hill_Out = k^n./(x.^n+k^n);
    
end

if normalized_flag
    Hill_Out = Hill_Out/(max(Hill_Out)-min(Hill_Out));
    Hill_Out = Hill_Out-min(Hill_Out);
end



end