% AUTHOR: An Do Dela 
% Date: May 28, 2021
% Purpose DeFAST simulation cancer model 

%% Cancer model 
% A Validated Mathematical Model of Cell-Mediated Immune
% Response to Tumor Growth
% Lisette G. de Pillis, Ami E. Radunskaya
% System contains 3 differential equations and 16 parameter 
% Local parameter sensitivity anlaysis has been done in the previous study
% 
%% Parameters ranges and model outputs are stored in Parameter_settings 
clear; close all; clc; 
warning('off');

% Sensitivity indices were generated and saved as Sobol_Cancer_data.mat
load('Sobol_Cancer_data.mat');
Parameter_settings;
Np= length(pmin); % number of parameters
ax = gca(); 

figure
ax = gca(); 
h= pie(ax, S_vec)
ax.Colormap = spring(numel(h)/2);
legend(Parameter_var)
set(gca,'FontSize',20)
title('First order SI')

figure; 
ax = gca(); 
h = pie(ax, ST_vec)
ax.Colormap = spring(numel(h)/2);
legend(Parameter_var)
set(gca,'FontSize',20)
title('Total order STi')

figure; 
hb = [S_vec ST_vec];
bar(hb)
set(gca,'XTick',[1:Np], 'XTickLabel',Parameter_var,'FontSize',20)
ylabel('Sensitivity index')
legend('First order sensitivity index','Total order sensitivity index')

