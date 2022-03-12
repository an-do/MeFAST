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
[sims,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 

%allocation
Gi = zeros(K,nT);
ratio = Gi;
plot_id = 1:500:sims;

for i =1:nT % timepoint
    for ss = 1: length(plot_id)
        ave = mean(abs(S(1:plot_id(ss),1:K-1,i)));
        sd = std(abs(S(1:plot_id(ss),1:K-1,i)));
        
        Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
        ratio(1:K-1,i) = ave./sd; % ratio mean/sd
        
        [~,~,ic] = unique(ratio(:,i),'sorted');
        rank_ratio(:,ss,i)=(1+max(ic)-ic); 
        
        [~,~,ic] = unique(Gi(:,i),'sorted');
        rank_Gi(:,ss,i)=(1+max(ic)-ic);        
    end 
    
end

%% Plotting convergence
%DAY 2000
figure(1)
plot(rank_ratio(:,:,1)', 'LineWidth',2)
set(gca,'FontSize',25, 'Xtick',1:10:length(plot_id), 'XtickLabel',1:5000:sims )
legend(Parameter_var)
title('Derivative ratio for day 2000')

%DAY 2000
figure(2)
plot(rank_Gi(:,:,1)','LineWidth',2)
xlim([0 140])
ylim([0 10])
set(gca,'FontSize',25, 'Xtick',1:10:length(plot_id), 'XtickLabel',1:5000:sims )
legend(Parameter_var)
title('Derivative Gi for day 2000')

%DAY 4000
figure(3)
plot(rank_ratio(:,:,2)')
set(gca,'FontSize',25)
legend(Parameter_var)
title('Derivative ratio for day 2000')

%DAY 4000
figure(4)
plot(rank_Gi(:,:,2)','LineWidth',2)
xlim([0 140])
ylim([0 10])
set(gca,'FontSize',25, 'Xtick',1:10:length(plot_id), 'XtickLabel',1:5000:sims )
legend(Parameter_var)
title('Derivative Gi for day 4000')


