N= 40;
N_us = 2;

TF1 = randi([0 1],1,N);
TF2 = randi([0 1],1,N);

TF1 = repelem(TF1,N_us);
TF2 = repelem(TF2,N_us);

T = TF1 & TF2;
T= 2*T-1;
T_sum = cumsum(T);

figure(1)
plot(T_sum,'-o');
% plot([TF1' TF2' T'])
