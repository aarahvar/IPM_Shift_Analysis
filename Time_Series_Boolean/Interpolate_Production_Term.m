function T_interp = Interpolate_Production_Term(Logic_Output,TF,plot_mesh_flag,Hill_fn_flag,normalized_hill_flag,n,k,shift_1,shift_2)
%%
% Create a set of grid points and corresponding sample values.
Num_TF = length(TF);
TF_Original = TF;

% Transform the TF levels according to their own mean
if Hill_fn_flag
    for i=1:Num_TF
        TF(i).TF = Hill_function(TF(i).TF,n,TF(i).mean,'up',normalized_hill_flag);
    end
end


%Generate command string like [X1,X2] = ndgrid(0:1);
for i=1:Num_TF
    if i==1
        out_str='[X1';
    else
        out_str = [out_str ',X' num2str(i)];
    end
    eval(['TF' num2str(i) '= TF(i).TF;']);
end
out_str = [out_str ']= ndgrid(0:1);'];
eval(out_str);

Logic_Output_Mtx = reshape(Logic_Output,Num_TF,Num_TF)';


%%
% Interpolate over a finer grid using |ntimes=1|.
if Num_TF==2
    %     T_interp2 = [1-TF1 TF1]*Logic_Output_Mtx*[1-TF2';TF2'];
    
    %The following code is linear interpn function
    %     for i=1:length(TF1)
    %         T_interp2(i,1) = [1-TF1(i) TF1(i)]*Logic_Output_Mtx*[1-TF2(i)';TF2(i)'];
    %     end
    
    [~,Max_Indx] = max([shift_1 shift_2]);
    Diff_shift = abs(shift_1-shift_2);
    
    if Max_Indx ==1
        T_interp = interpn(X1,X2,Logic_Output_Mtx,TF1(1:end-Diff_shift),TF2(Diff_shift+1:end),'linear');
    elseif Max_Indx==2
        T_interp = interpn(X1,X2,Logic_Output_Mtx,TF1(Diff_shift+1:end),TF2(1:end-Diff_shift),'linear');
    end
    
elseif Num_TF==3
    T_interp = interpn(X1,X2,X3,Logic_Output_Mtx,TF1,TF2,TF3,'linear');
elseif Num_TF==4
    T_interp = interpn(X1,X2,X3,X4,Logic_Output_Mtx,TF1,TF2,TF3,TF4,'linear');
end

if plot_mesh_flag && Num_TF==2
    figure(20)
    [Xq1,Xq2]=ndgrid(sort(TF(1).TF),sort(TF(2).TF));
    Vq = interpn(X1,X2,Logic_Output_Mtx,Xq1,Xq2,'linear');
    [Xq1,Xq2]=ndgrid(sort(TF_Original(1).TF),sort(TF_Original(2).TF));
    mesh(Xq1,Xq2,Vq);
    box on
    xlabel('A')
    ylabel('B')
end
