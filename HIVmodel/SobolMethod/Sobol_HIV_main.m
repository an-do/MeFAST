%AUTHOR: An Do Dela 
%Date: May, 2021
% PURPOSE: Sobol's method on HIV model 

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)
%% Table of parameters and ranges is given in the manuscript

% Model parameters and range of uncertainty is set up in Parameter_settings_EFAST_Marino.m 
% and the system of differential equations in ODE_efast.m
warning('off');
tic 

Parameter_settings;
Np = length(pmin); % number of parameters 
%% 
% There are 2 different time points of interest: 
% 1) 2000 days and 2) 4000 days. 


% Number of simulations i.e. rows of Latin hypercube sampling matrix 

N = 100000;

disp(['Number of simulations are ', num2str(N)])

%% 
% We cgenerate 2 LHS matrix A and B. 
% Also we will form the following matrices: 
%
% ABi matrix: formed by all colums of A except the k column, 
% which comes from matrix B
% 
% BAi matrix: formed by all colums of B except the k column, 
% which comes from A

A = zeros(N/2,Np); % allocation
B = A;

for i =1 : Np %looping over parameter 
A(:,i) = LHS_Call(pmin(i), baseline(i), pmax(i), 0 ,N/2,'unif');
B(:,i) = LHS_Call(pmin(i), baseline(i), pmax(i), 0 ,N/2,'unif');
end


BAi = cell(1,Np);

for k = 1:Np
    BAi{k} = B;
    BAi{k}(:,k) = A(:,k);
end

ABi = cell(1,Np);
for k = 1:Np
    ABi{k} = A;
    ABi{k}(:,k) = B(:,k);
end
%% Simulate the model output for every row of matrix A, B, ABi and BAi 
% at a particular time_point of interest of a particular y variable 
% taking viral load as analysis metrics 

 YA = zeros(N/2,1); 
 YB = zeros(N/2,1);

time_points = 2000; 
y_var = 4; 

disp('Start simulating model for matrix A and B')
parfor run_num=1:N/2 %remember to turn on for paralell computing 
%-------------------solve ODE-------------------%  
f=@ODE_model; 

[~,yA]=ode15s(@(t,y)f(t,y,A,run_num),tspan,y0,[]);
[~,yB]=ode15s(@(t,y)f(t,y,B,run_num),tspan,y0,[]);

% save output as vector so that now we can store data as in T1D case 
YA(run_num) = yA(time_points(1) +1,y_var)  ;
YB(run_num) = yB(time_points(1) +1,y_var)  ;

end %run_num=1:N

Vtot=var([YA;YB]); % total variance 
%% Calculate the mean and unconditional variance of the model output 

 YABi = cell(1,Np);
 YBAi = cell(1,Np);
 S_vec = zeros(Np,1); 
 ST_vec = zeros(Np,1);
 
disp('Start simulatingß model for matrix ABi and BAi')

parfor k = 1:Np% loop over parameter
disp(['Simulate for parameter ', num2str(k), ' out of ',...
    num2str(Np), ' parameters'])

    for run_num=1:N/2 %loop over row of matrix 
        f=@ODE_model;    
        [~, yBAi]= ode15s(@(t,y)f(t,y,BAi{k},run_num),tspan,y0,[]);
        [~, yABi]= ode15s(@(t,y)f(t,y,ABi{k},run_num),tspan,y0,[]);
        YBAi{k}(run_num) = yBAi(time_points(1) +1,y_var);
        YABi{k}(run_num) = yABi(time_points(1) +1,y_var);
    end %runnum
    
    disp(['Compute variance for parameter p',num2str(k)])
    
    Vi =  mean(YB.*(abs(YABi{k}'-YA)));
    VTi = mean((YA-YABi{k}').^2)/2;
    
    S_vec(k) = Vi/Vtot;
    ST_vec(k) = VTi/Vtot;
    
end


[Si, Si_id]= sortrows(S_vec,'descend');
Ti = table(Parameter_var(Si_id),Si);



[STi, STi_id]= sortrows(ST_vec,'descend');
Ttoti = table(Parameter_var(STi_id),STi);

time= toc;

dlmwrite('Sobol_runtime.csv',time,'-append') % save elapse time. 

save 'Sobol_HIV_sdata.mat' 



%% 
% Make sure to turn off parpool at the end 

delete(gcp('nocreate'))
