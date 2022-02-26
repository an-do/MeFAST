% AUTHOR: An Do Dela 
% Date: May 28, 2021
% Purpose DGSM simulation cancer model 

%% Cancer model 
% A Validated Mathematical Model of Cell-Mediated Immune
% Response to Tumor Growth
% Lisette G. de Pillis, Ami E. Radunskaya
% System contains 3 differential equations and 16 parameter 
% Local parameter sensitivity anlaysis has been done in the previous study
% 
% 
%parameters and range of uncertainty are stired in Parameter_settings
Parameter_settings;
K = length(pmin); % number of parameters 

% Taking viral load at 2 different time points of interest: 
% 1) 25 days and 2) 50 days. 

time_points=[25,50];

% sensivity measures associated with DGSM were generated and saved as
% Derivative_data.mat
load('Derivative_Cancer_data.mat')

S = sens_rel_mat.*LHSmatrix; 
[~,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 

%allocation
Gi = zeros(K,nT);
ratio = Gi;

for i =1:nT % timepoint 
    ave = mean(abs(S(:,1:K-1,i)));
    sd = std(abs(S(:,1:K-1,i)));
    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
    ratio(1:K-1,i) = ave./sd; % ratio mean/sd
end


%% Plotting DGSM ratio and Gi for each parameter
 
Parameter_settings; % Loading parameters names and sampling ranges
K = length(pmin); % number of parameters 


% Load the simulated data from above
% Just in case users need to restart the computer

load('Derivative_Cancer_data.mat')

S = sens_rel_mat.*LHSmatrix; 
[~,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 

%allocation
Gi = zeros(K,nT);
ratio = Gi;

for i =1:nT % timepoint 
    ave = mean(abs(S(:,1:K-1,i)));
    sd = std(abs(S(:,1:K-1,i)));
    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
    ratio(1:K-1,i) = ave./sd; % ratio mean/sd
end

% Plot Day 25
[~, sort_id_ratio] = sortrows(ratio(:,1));
figure(1)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 25')

id_max= Gi(:,1)==max(Gi(:,1)); 
plotGi = Gi;
plotGi(id_max,1)= NaN;
plotGi = plotGi(:,1)/1e+7; 
[~, sort_id_Gi] = sortrows(plotGi(:,1),'ascend');

figure(2)
plot(Gi(:,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Unsorted and include outlier')
title('Derivative Gi for day 25')

figure(3)
plot(plotGi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',20)
legend('Sorted and remove outlier')
title('Derivative Gi for day 25')

%Plot day 50

[~, sort_id_ratio] = sortrows(ratio(:,2));
figure(4)
plot(ratio(sort_id_ratio,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 50')

id_max= Gi(:,2)==max(Gi(:,2)); 
plotGi = Gi;
plotGi(id_max,2)=NaN;
plotGi = plotGi/10e9; 
[~, sort_id_Gi] = sortrows(plotGi(:,2),'ascend');

figure(5)
plot(Gi(:,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Unsorted and include outlier')
title('Derivative Gi for day 50')

figure(6)
plot(plotGi(sort_id_Gi,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',20)
legend('Sorted and remove outlier')
title('Derivative Gi for day 50')

