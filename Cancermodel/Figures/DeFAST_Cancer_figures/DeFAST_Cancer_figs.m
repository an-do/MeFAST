% AUTHOR: An Do Dela 
% Date: May 28, 2021
% Purpose DeFAST simulation HIV model 

%% Cancer model 
% A Validated Mathematical Model of Cell-Mediated Immune
% Response to Tumor Growth
% Lisette G. de Pillis, Ami E. Radunskaya
% System contains 3 differential equations and 16 parameter 
% Local parameter sensitivity anlaysis has been done in the previous study
% 
%% Table of parameters and ranges is given in the manuscript
% and is stored in Parameter_settings
% 
% Model parameters and range of uncertainty  
disp('DeFAST analysis on Cancer model using pre-generated data.')


% Parameter ranges setting is here 
Parameter_settings;
K = length(pmin); % number of parameters 

time_points=[25 50]; %time points in days 

%% Sensitivity indices were generated and saved as eFAST_data.mat
% To reproduce this result, run Tutorial_eFAST_HIV.mlx in the eFAST folder
% We perform eFAST for $N_R =400$ with  on a paralellized 

%% DeFAST analysis  
% results- First order sensitivity indices $S_i$ 
% The last input of the function indicates the time point at which the analysis 
% is avaluated. 1 = 25 days and 2 = 50 days

%[S, id]=DeFAST_analysis('Defast_Cancer_data.mat',0.05,'Si',1,1)

% Generate summary table of parameters and their associate first 
% order sensitivity indices

index = 1:max(id)
tbl = table(index', Parameter_var(id),S(index));
tbl.Properties.VariableNames= {'Index','Parameters','First order SI'}

%% 
%% DeFAST results- Total order sensitivity indices $S_tot$ 

[Stot, id]=DeFAST_analysis('DeFAST_Cancer_data.mat',0.05,'Sti',1,1)
tbl = table(index', Parameter_var(id),Stot(index));
tbl.Properties.VariableNames= {'Index','Parameters','Total order SI'}

warning('on');

%% The end  
