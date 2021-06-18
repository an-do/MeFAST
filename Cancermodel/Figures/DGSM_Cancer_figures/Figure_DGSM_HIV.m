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

%% Plot 
figure(1)
plot(ratio(:,1),'-*','LineWidth',2);
hold on; 
plot(Gi(:,1)/max(Gi(:,1)),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Derivative ratio', 'Derivative Gi')
ylabel(['Tumor volume at day ', num2str(time_points(1))])
%% 
figure(2)
plot(ratio(:,2),'-*','LineWidth',2);
hold on; 
plot(Gi(:,2)/max(Gi(:,2)),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Derivative ratio', 'Derivative Gi')
ylabel(['Tumor volume at day ', num2str(time_points(2))])

