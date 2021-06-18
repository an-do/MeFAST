%% This routine is to creat LHS matrix 
% which is based on Marino algorithm. 

clear all;
close all;

%% Sample size N
runs=10000;

%% LHS MATRIX  %%
% make vectors of parameter values 

Parameter_settings_LHS; 
k = size(pmax,1); 
LHSmatrix = zeros(runs, k); 

for i =1 : k 
    LHSmatrix(:,i) = LHS_Call(pmin(i), baseline(i), pmax(i), 0 ,runs,'unif');
end 

csvwrite('LHS.csv', LHSmatrix); %save LHS matrix

