% AUTHOR: An Do Dela (an.do@cgu.edu)
% DATE: May 24th, 2021

% PURPOSE: script file to generate DGSM analysis for HIV model 

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)
%
% 
% Model parameters and range of uncertainty  
Parameter_settings;
K = length(pmin); % number of parameters 

% Taking viral load at 2 different time points of interest: 
% 1) 2000 days and 2) 4000 days. 

time_points=[2000 4000]; %time points in days 

% sensivity measures associated with DGSM were generated and saved as
% Derivative_data.mat
load('Derivative_HIV_data.mat')

S = sens_rel_mat.*LHS; 
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
% 
% %--------- Total order 
% 
% figure(2)
% plot(ratio(:,2),'-*','LineWidth',2);
% hold on; 
% plot(Gi(:,2)/max(Gi(:,2)),'-*','LineWidth',2);
% set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
% legend('Derivative ratio', 'Derivative Gi')

