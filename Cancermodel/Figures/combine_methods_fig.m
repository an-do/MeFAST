%HIV model: timepoint of interest 2000 days. The model is already reached
%the steady state. Marino performed the sensitivity at 2000 days and 4000
%days but both analysis is identical 
clear; close all; clc 
Parameter_settings;


%% For eFAST
load('./DeFAST_Cancer_figures/DeFAST_Cancer_data.mat'); 

Si_eFAST = squeeze(mean(rangeSi(:,:,:,1)))';
Sti_eFAST = squeeze(mean(rangeSti(:,:,:,1)))';


%% Sobol 
load('./Sobol_Cancer_figures/Sobol_Cancer_data.mat');

Si_Sobol= S_vec; 
ST_Sobol= ST_vec; 

[~,idst] = sortrows(ST_Sobol(:,1),'descend');
Parameter_var(idst)

%% Plot 
figure(20)
[~,idst] = sortrows(Sti_eFAST(:,1),'descend');

plot(Sti_eFAST(idst,1),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',20)
legend('DeFAST Total order', 'Sobol Total order')
title('day 25')
%--------- Total order 

figure(21)
[~,idst] = sortrows(Sti_eFAST(:,2),'descend');

plot(Sti_eFAST(idst,2),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',20)
legend('DeFAST Total order', 'Sobol Total order')
title('day 50')

%% Plotting DGSM ratio and Gi for each parameter
load('./DGSM_Cancer_figures/Derivative_Cancer_data.mat')

S = sens_rel_mat.*LHSmatrix; 
[~,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 
Gi = zeros(K,nT);
ratio = Gi;

for i =1:nT % timepoint 
    ave = mean(abs(S(:,1:K-1,i)));
    sd = std(abs(S(:,1:K-1,i)));
    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2);
    ratio(1:K-1,i) = ave./sd;
end

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

