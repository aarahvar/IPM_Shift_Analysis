function [Entropy,Sorted_Entropy,Sorted_Shift_Index,Detected_Output_Over_Shift]=Find_Entropy_Double_Shift(max_shift,TF_b,T_b,Remove_percent)

Entropy = zeros(max_shift);
%Detected_Output_Over_Shift = zeros(max_shift+1,4);

for shift_Detect_1 = 0:max_shift
    for shift_Detect_2 = 0:max_shift
        %Find the probability of 0 and 1 as the detected output for each input state
        [Cnt_0_1,P_0_1] = Detect_Logic_in_TimeSeries(TF_b,T_b,shift_Detect_1,shift_Detect_2,[],0);
        
        %Calculate entropy
        Entropy(shift_Detect_1+1,shift_Detect_2+1) = Find_Entropy_01(Cnt_0_1,P_0_1,Remove_percent);
        
        [~,max_indx] =  max(Cnt_0_1');
        Detected_Output_Over_Shift_struct(shift_Detect_1+1).Logic(shift_Detect_2+1,:)=max_indx-1;
    end
end

%Find the index of the minimum Entropy
Sorted_Entropy = sort(Entropy(:));
Sorted_Shift_Index = zeros(length(Sorted_Entropy),2);
Detected_Output_Over_Shift=[];
m=0;

Same_Entropy = [];
for i=1:length(Sorted_Entropy)
    [Shift_1,Shift_2]= find(Entropy==Sorted_Entropy(i));
    
    %If an entopy value occurs more than one time, we should process that value only once
    %To do this, we store these values of entropy and monitor by this vector if the current entropy has been observed before or not
    if length(Shift_1)>1
       if ismember(Sorted_Entropy(i),Same_Entropy)
           continue
       else
           Same_Entropy = [Same_Entropy Sorted_Entropy(i)];
       end
    end
    
    Shift_1 = Shift_1-1;
    Shift_2 = Shift_2-1;
    
    %If we have a value in multiple places, 'find' will return more than one value
    %the followin for loop in for handling this situation.
    for k=1:length(Shift_1)
        m = m+1;
        [i m]
        Sorted_Shift_Index(m,:) = [Shift_1(k) Shift_2(k)];
        Detected_Output_Over_Shift(end+1,:) = Detected_Output_Over_Shift_struct(Shift_1(k)+1).Logic(Shift_2(k)+1,:);
    end
    
end

end