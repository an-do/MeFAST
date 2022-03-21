% AUTHOR: An Do Dela (an.do@cgu.edu)
% DATE: May 20th, 2021

% Portion of this script was adapted from Marino et a. 2008 
% http://malthus.micro.med.umich.edu/lab/usadata/
% Marino, Simeone, et al. "A methodology for performing global uncertainty
% and sensitivity analysis in systems biology." 
% Journal of theoretical biology 254.1 (2008): 178-196.

% PURPOSE: script file to generate eFAST analysis for HIV model 

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)
 
clear; 
close all; 
clc; 

% Model parameters and range of uncertainty  
disp('MeFAST analysis on HIV model using pre-generated data.')
disp('Run time is about 10 minutes')

% Parameter ranges setting is here 
Parameter_settings;
K = length(pmin); % number of parameters 

% We take viral load at time points as analysis metrics 
% 1) 2000 days and 2) 4000 days. 

time_points=[2000 4000]; %time points in days 

%% Sensitivity indices were generated and saved as eFAST_data.mat
% To reproduce this result, run Tutorial_eFAST_HIV.mlx in the eFAST folder
% We perform MeFAST for $N_R =400$ with  on a paralellized 


%% DeFAST results- Total order sensitivity indices $S_ti$ at 2000 days

[Stot, id]=MeFAST_analysis('MeFAST_HIV_data.mat',0.05,'Sti',4,1);

%% DeFAST results- Total order sensitivity indices $S_ti$ at 4000 days

[Stot, id]=MeFAST_analysis('MeFAST_HIV_data.mat',0.05,'Sti',4,2);


