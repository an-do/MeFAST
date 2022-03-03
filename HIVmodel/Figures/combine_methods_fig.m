%HIV model: timepoint of interest 2000 days. The model is already reached
%the steady state. Marino performed the sensitivity at 2000 days and 4000
%days but both analysis is identical 
clear; close all; clc;
warning('off')

Parameter_settings;

%% derivative base 
load('./DGSM_HIV_figures/Derivative_HIV_data.mat');

S = sens_rel_mat.*mat; 
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

%% For eFAST
load('./DeFAST_HIV_figures/DeFAST_HIV_data.mat'); 

Si_eFAST = squeeze(mean(rangeSi(:,:,:,4)))';
Sti_eFAST = squeeze(mean(rangeSti(:,:,:,4)))';


%% Sobol 
load('./Sobol_HIV_figures/Sobol_HIV_data.mat');

Si_Sobol= S_vec; 
ST_Sobol= ST_vec; 


%% Plot 
figure(1)
[~,ids] = sortrows(Si_eFAST(:,1),'descend');

plot(Si_eFAST(ids,1),'-*','LineWidth',2); 
hold on; 
plot(Si_Sobol(ids),'-*','LineWidth',2);
hold on; 
plot(ratio(ids,1),'-*','LineWidth',2);
 hold on; 
 plot(Gi(ids,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(ids),'FontSize',20)
legend('eFAST First order', 'Sobol First order','Derivative ratio', 'Derivative Gi')

%--------- Total order 

figure(2)
[~,idst] = sortrows(Sti_eFAST(:,1),'descend');

plot(Sti_eFAST(idst,1),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
% hold on; 
% plot(ratio(ids,1),'-*','LineWidth',2);
% hold on; 
%  plot(Gi(ids,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',30)
%legend('eFAST Total order', 'Sobol Total order','Derivative ratio', 'Derivative Gi')
legend('eFAST Total order', 'Sobol Total order')


id_max= Gi(:,1)==max(Gi(:,1)); 
plotGi = Gi(:,1);
[~, sort_id_Gi] = sortrows(plotGi(:,1),'descend');

figure(11)
plot(plotGi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)

[~, sort_id_ratio] = sortrows(ratio(:,1),'descend');
figure(12)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',30)
title('Derivative ratio for day 2000')



