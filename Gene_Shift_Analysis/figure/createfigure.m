
Hmin = [13     4    30     1     1     3    18     3]';
Consistent = [12     4    29     1     1     1    20     5]';

A= [ Hmin Consistent];

Hmin_validated = [3     4     6     1     1     0     8     1]';
Consistent_Validated = [5     4    16     1     1     1    18     2]';
A_validated = [Hmin_validated Consistent_Validated];

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

bar1=bar(A)
bar2=bar(A_validated)
% Create multiple lines using matrix input to bar
% bar1 = bar(ymatrix1,'Parent',axes1);
set(bar1(1),'DisplayName','Entropy_m_i_n - Total','FaceColor',[0 1 1]);
set(bar1(2),'DisplayName','Consistent - Total');
set(bar2(1),'DisplayName','Entropy_m_i_n - Validated');
set(bar2(2),'DisplayName','Consistent - Validated','FaceColor',[0.850980392156863 0.325490196078431 0.0980392156862745]);

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[1 2 3 4 5 6 7 8 ],'XTickLabel',{'AND','OR','RF_1*~RF_2','XOR','XNOR','RF_1+~RF_2','NOR','NAND'});
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'FontSize',12);

