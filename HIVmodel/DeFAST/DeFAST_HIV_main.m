% AUTHOR: An Do Dela 
% Date: May 28, 2021
% Purpose DeFAST simulation HIV model 

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)
%% Table of parameters and ranges is given in the manuscript
% 
% 
% 
% 
% Model parameters and range of uncertainty is set up in Parameter_settings_EFAST_Marino.m 
% and the system of differential equations in ODE_efast.m
warning('off');

Parameter_settings;
K = length(pmin); % number of parameters 
%% 
% There are 2 different time points of interest: 
% 1) 2000 days and 2) 4000 days. 

time_points=[2000 4000]; %time points in days 

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

%% Actual simulation 
%% Here we commented this part of the code because we already obtained the results previously. 

NR = 400; %resampling size
parpool % turn on to use parallel computing in cluster
tic 
[rangeSi, rangeSti] = Model_efast(NR,pmin,pmax,...
   time_points, @ODE_model);
elapse = toc;
dlmwrite('DeFAST_runtime.csv',[NR,elapse],'-append') % save elapse time. 
delete(gcp('nocreate')) % turn off parallel computing

%% DeFAST analysis  
% results- First order sensitivity indices $S_i$ at 2000 days
% The last input of the function indicates the time point at which the analysis 
% is avaluated. 1 = 2000 days and 2 = 4000 days

[S, id]=DeFAST_analysis('DeFAST_HIV_data.mat',0.05,'Si',4,1)

% Generate summary table of parameters and their associate first 
% order sensitivity indices

index = 1:max(id)
tbl = table(index', Parameter_var(id),S(index));
tbl.Properties.VariableNames= {'Index','Parameters','First order SI'}

%% 
%% DeFAST results- Total order sensitivity indices $S_i$ at 2000 days

[Stot, id]=DeFAST_analysis('DeFAST_HIV_data.mat',0.05,'Sti',4,1)
tbl = table(index', Parameter_var(id),Stot(index));
tbl.Properties.VariableNames= {'Index','Parameters','Total order SI'}

warning('on');
%% 
% 
% 
%