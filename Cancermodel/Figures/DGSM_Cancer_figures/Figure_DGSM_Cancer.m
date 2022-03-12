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

S = sens_rel_mat.*mat; 
[~,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 

%allocation
Gi = zeros(K,nT);
ratio = Gi;

for i =1:nT % timepoint 
    ave = mean(abs(S(:,1:K-1,i)));
    sd = std(abs(S(:,1:K-1,i)));
    
    figure(10+i)
    scatter(ave,sd,'filled')
    title(['Day ', num2str(time_points(i))]);
    set(gca,'YScale', 'log','FontSize',20)
    
    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
    ratio(1:K-1,i) = ave./sd; % ratio mean/sd
end


%% Plotting DGSM ratio and Gi for each parameter
% Plot Day 25
[~, sort_id_ratio] = sortrows(ratio(:,1),'descend');

figure(1)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',30)
title('Derivative ratio for day 25')


plotGi = Gi(:,1);
[~, sort_id_Gi] = sortrows(plotGi(:,1),'descend');


figure(2)
plot(Gi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',20)
title('Derivative Gi for day 25')


%Plot day 50

[~, sort_id_ratio] = sortrows(ratio(:,2),'descend');

figure(4)
plot(ratio(sort_id_ratio,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 50')

[~, sort_id_Gi] = sortrows(Gi(:,2),'descend');

figure(5)
plot(Gi(sort_id_Gi,2),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)
title('Derivative Gi for day 50')


