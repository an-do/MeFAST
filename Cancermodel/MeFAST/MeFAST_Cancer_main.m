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

Parameter_settings;
K = length(pmin); % number of parameters 
time_points=[25, 50]; %time points of interest in days 

%% Simulate models and compute sensitivity indices
% We run the eFAST analysis for 400 times ($N_R =400$) and compute both first 
% and total order sensitivity indices as described in the following diagram. 
% 
% 
% 
% In the following code, we perform eFAST for $N_R =400$ with  on a paralellized 
% code using parpool which output a structure of all the the sensitivity indices. 
% 
% This process may take some time.
% See runtime.csv for more details

NR = 40; %400; %resampling size

parpool %turn on to use parallel computing in cluster
tic 
[rangeSi, rangeSti] = Model_efast(NR,pmin,pmax,...
   time_points, @ligandOde);

elapse = toc;
dlmwrite('runtime.csv',[NR,elapse],'-append') % save elapse time. 

delete(gcp('nocreate')) % turn off parallel computing

%% DeFAST results- Total order sensitivity indices $S_tot$ 
% results- First order sensitivity indices $S_i$ 
% The last input of the function indicates the time point at which the analysis 
% is avaluated. 1 = 25 days and 2 = 50 days

[S, id] = MeFAST_analysis('Mefast_Cancer_data.mat',0.05,'Sti',1,1)
[Stot, id] = MeFAST_analysis('MeFAST_Cancer_data.mat',0.05,'Sti',1,2)


warning('on');
