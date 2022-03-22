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
load('./MeFAST_HIV_figures/MeFAST_HIV_data.mat'); 

Si_eFAST = squeeze(mean(rangeSi(:,:,:,4)))';
Sti_eFAST = squeeze(mean(rangeSti(:,:,:,4)))';


%% Sobol 
load('./Sobol_HIV_figures/Sobol_HIV_data.mat');

Si_Sobol= S_vec; 
ST_Sobol= ST_vec; 


%% Plot 

%--------- Day 2000

figure(2)
[~,idst] = sortrows(Sti_eFAST(:,1),'descend');

plot(Sti_eFAST(idst,1),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',30)
legend('MeFAST', 'Sobol method')


plotGi = Gi(:,1);
[~, sort_id_Gi] = sortrows(plotGi(:,1),'descend');

figure(11)
plot(plotGi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)
title('Derivative Gi for day 2000')

[~, sort_id_ratio] = sortrows(ratio(:,1),'descend');
figure(12)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',30)
title('Derivative ratio for day 2000')



%--------- Day 4000

figure(3)
[~,idst] = sortrows(Sti_eFAST(:,2),'descend');

plot(Sti_eFAST(idst,2),'-*r','LineWidth',2); 
hold on; 
plot(ST_Sobol(idst),'-*blue','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(idst),'FontSize',30)
legend('MeFAST Total order', 'Sobol Total order')


plotGi = Gi(:,2);
[~, sort_id_Gi] = sortrows(plotGi,'descend');

figure(4)
plot(plotGi(sort_id_Gi),'-*','LineWidth',2);
set(gca,'YScale', 'log','XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',30)
title('Derivative Gi for day 4000')

[~, sort_id_ratio] = sortrows(ratio(:,1),'descend');
figure(13)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',30)
title('Derivative ratio for day 4000')



