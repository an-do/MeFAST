%HIV model: timepoint of interest 2000 days. The model is already reached
%the steady state. Marino performed the sensitivity at 2000 days and 4000
%days but both analysis is identical 
clear; close all; clc 

Parameter_settings;

%% derivative base 
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

%% For eFAST
load('./DeFAST_Cancer_figures/DeFAST_Cancer_data.mat'); 

Si_eFAST = squeeze(mean(rangeSi(:,:,:,1)))';
Sti_eFAST = squeeze(mean(rangeSti(:,:,:,1)))';


%% Sobol 
load('./Sobol_Cancer_figures/Sobol_Cancer_data.mat');

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
plot(Gi(ids,1)/max(Gi(:,1)),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(ids),'FontSize',20)
legend('eFAST First order', 'Sobol First order','Derivative ratio',...
    'Derivative Gi')

%--------- Total order 

figure(2)
[~,idst] = sortrows(Sti_eFAST(:,1),'descend');

plot(Sti_eFAST(idst,1),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
hold on; 
plot(ratio(idst,1),'-*black','LineWidth',2);
hold on; 
plot(Gi(idst,1)/max(Gi(:,1)),'-*green','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',20)
legend('eFAST Total order', 'Sobol Total order','Derivative ratio',...
    'Derivative Gi')

%-------- Bar plot 
figure(3)
[~,idst] = sortrows(Sti_eFAST(:,1),'descend');
combine = [Sti_eFAST(idst,1) ST_Sobol(idst) ratio(idst,1) ...
    Gi(idst,1)/max(Gi(:,1))]
bar(combine)
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',20)
legend('eFAST', 'Sobol','Derivative ratio', 'Derivative Gi')
ylabel('Total order')

figure(4)
[~,idst] = sortrows(ST_Sobol,'descend');
combine = [ ST_Sobol(idst) ratio(idst,1) Gi(idst,1)/max(Gi(:,1))]
bar(combine)
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',20)
legend('Sobol','Derivative ratio', 'Derivative Gi')
ylabel('Total order')


