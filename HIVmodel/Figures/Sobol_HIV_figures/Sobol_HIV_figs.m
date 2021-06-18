% AUTHOR: An Do Dela (an.do@cgu.edu)
% DATE: May 20th, 2021


% PURPOSE: script file to generate Sobol's method analysis for HIV model 

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)
% Taking viral load at day 2000 and 4000 as metrics


% Model parameters and range of uncertainty is saved in Parameter_settings

% Sensitivity indices were generated and saved as Sobol_HIV.mat
load('Sobol_HIV_data.mat');
Parameter_settings;

figure
subplot(2,2,1)
pie(S_vec)
legend(Parameter_var)
set(gca,'FontSize',20)
title('First order SI')

subplot(2,2,2)
pie(ST_vec)
legend(Parameter_var)
set(gca,'FontSize',20)
title('Total order STi')

subplot(2,2,[3 4])
hb = [S_vec ST_vec];
bar(hb)
set(gca,'XTick',[1:Np], 'XTickLabel',Parameter_var,'FontSize',20)
ylabel('Sensitivity index')
legend('First order sensitivity index','Total order sensitivity index')

