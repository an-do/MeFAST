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

% Taking viral load at day 2000 

time_points=[2000,4000]; %time points in days 

% sensivity measures associated with DGSM were generated and saved as
% Derivative_data.mat
load('Derivative_HIV_data.mat')

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
    set(gca,'FontSize',20)

    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
    ratio(1:K-1,i) = ave./sd; % ratio mean/sd
end

%% Plotting analysis results
% Day 2000
[~, sort_id_ratio] = sortrows(ratio(:,1));

figure(1)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',25)
title('Derivative ratio for day 2000')

plotGi = Gi(:,1);
[~, sort_id_Gi] = sortrows(plotGi(:,1),'descend');

figure(2)
plot(plotGi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)
title('Derivative Gi for day 2000')



% Day 4000
[~, sort_id_ratio] = sortrows(ratio(:,2));

figure(3)
plot(ratio(sort_id_ratio,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 4000')

plotGi = Gi(:,2);
[~, sort_id_Gi] = sortrows(plotGi,'descend');

figure(4)
plot(plotGi(sort_id_Gi),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)
title('Derivative Gi for day 4000')

%% Convergence 


