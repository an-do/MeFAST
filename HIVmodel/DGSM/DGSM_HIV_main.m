%AUTHOR: An Do Dela 
%Date: May, 2021
% PURPOSE: Derivative global measures method on HIV model 


clear all 
close all

%% System of differential equations 
% The model consists of a system of ordinary differential equations (ODEs) that 
% describe 4 cell populations in the blood: 1) uninfected T cells 2) latently 
% infected T cells ($T^*$) that contains provirus but yet to produce new viruses 
% and 3) actively infected T cells ($T^{**}$) that produce new viruses 4) free 
% virus (V)

myfun = @ODE_model;
Nrow= 100000;

%% Table of parameters and ranges is given in the manuscript

% Model parameters and range of uncertainty is set up in Parameter_settings_EFAST_Marino.m 
% and the system of differential equations in ODE_efast.m

%% 
% There are 2 different time points of interest: 
% 1) 2000 days and 2) 4000 days. 

warning('off');
Parameter_settings;
k = length(pmin); % number of parameters 

% Solver tolerance 
ODE_TOL  = 1e-10;
DIFF_INC = sqrt(ODE_TOL);


%parpool % remember to turn on
tic 


% Number of rows of sampling matrix i.e. number of simulations
% Generating sampling matrix using Latin hypercube sampling routine

mat = zeros(Nrow, k); 

for i =1 : k 
    mat(:,i) = LHS_Call(pmin(i),...
 baseline(i), pmax(i), 0 ,Nrow,'unif');
end 

%% The matrix will be saved as a csv file to be used later. 
csvwrite('LHS.csv', mat); %save LHS matrix


%% load parameter set generated by latin hypercube sampling
mat = dlmread('LHS.csv');
% the smallest step size between each parameter values
dp = abs(min(diff(mat))); 

%% 
% We will then calculate the sensitivity matrix. For each parameter $x_i$, 
% a local sensitivity measure is calculated based on the parital derivative 
% 
% $$E_i \left(x^* \right)=\frac{\partial f}{\partial x_i }$$
% 
% The local sensitivity measures $E_i \left(x^* \right)$ depends on a nomial 
% point $x^*$ and it changes with a change of $x^*$. This deficiency can be overcome 
% by averaging repeating $E_i \left(x^* \right)$over the parameter space. 
% 
% We are interested in anlyzing the model output for virus load at a particular 
% time point 

y_var = 4; 
out = zeros(Nrow, length(tspan)); % tspan is defined in Parameter settings
time_points =[2000 4000]; 

sens_mat = zeros(Nrow,k,length(time_points)); 
sens_rel_mat = sens_mat;

% This portion of code is adapted from 
% Gallaher, Jill, et al. 
% "Methods for determining key components in a mathematical model for
% tumor–immune dynamics in multiple myeloma." 
% Journal of theoretical biology 458 (2018): 31-46.

%% Simulating the model for each row of LHS matrix 

disp('Simulating model output for each row of sampling matrix')
parfor run_num =1:Nrow %parfor 
    
    run_num
    f=myfun; 
    opts = odeset('AbsTol',10^(-6)); % add AbsTol option
   

    f0 = zeros(size(time_points)); 
    f1 =f0;

% sensitivity matrices for changes in parameter and initial conditions
%[sens0, sensR, flagg, y, sol] = senseq(pars,xdata);

%------------- solve ODE at a nomial value ----------------%  
[~,y]=ode15s(@(t,y)f(t,y,mat,run_num),tspan,y0,[]);
    
    
    f0 = [y(tspan==time_points(1),y_var)...
                     y(tspan==time_points(2),y_var)]; 
    %out(run_num,:) = f0;
    

    for j = 1:k

        % for each parameter, slightly perturb its value and evaluate the function 
        epsnew = DIFF_INC;

        % parameter delta step = nonzero smallest parameter difference step
        %delta_p_vector = sort(abs(diff(mat(:,j))));

        %id = 1:1:runs-1;
        %dp = delta_p_vector(min(id(delta_p_vector~=0))); 

        % compare parameter perturbation with parameter step size 
        % if parameter perturbation > step size then redefine perturbation 
        % otherwise, it remains the same 

        if epsnew > dp(j) 
            epsnew = dp(j)/2; 
        end 

        new_mat = mat(run_num,:); % extract the nomial row of LHS 
        new_mat(j) = new_mat(j)+ epsnew; %perturb x_j value 

        [~,y]=ode15s(@(t,y)f(t,y,new_mat,1),tspan,y0,[]);



        f1 = [y(tspan==time_points(1),y_var)...
                     y(tspan==time_points(2),y_var)]; 

        %%Relative sensitivity = change in glucose/epsilon
        %sens_mat(run_num,j,:)   = (f1 - f0)/(epsnew);
        sens_mat(run_num,j,:)   = (f1 - f0)/(f0*epsnew); %mod May 28
        sens_rel_mat(run_num,j,:) = squeeze(sens_mat(run_num,j,:))'./...
            f0;

    end% j parameter



end %run_num

save('DGSM_data.mat','mat','sens_mat','sens_rel_mat') 
delete(gcp('nocreate'))

time= toc;
dlmwrite('derivative_runtime.csv',time,'-append') % save elapse time.


%% Plotting DGSM ratio and Gi for each parameter
 
Parameter_settings; % Loading parameters names and sampling ranges
K = length(pmin); % number of parameters 

% Model outcome of interest: viral load at 1) 2000 days and 2) 4000 days. 

time_points=[2000 4000]; % (days) 

% Load the simulated data from above
% Just in case users need to restart the computer

load('DGSM_data.mat')

S = sens_rel_mat.*mat; 
[~,K,nT]=size(S);

S(:,end,:) = []; %remove dummy parameter statistics 

%allocation
Gi = zeros(K,nT);
ratio = Gi;

for i =1:nT % timepoint 
    ave = mean(abs(S(:,1:K-1,i)));
    sd = std(abs(S(:,1:K-1,i)));
    Gi(1:K-1,i) = sqrt(ave.^2 + sd.^2); % square root mean^2 + sd^2 
    ratio(1:K-1,i) = ave./sd; % ratio mean/sd
end

% Plot Day 2000
[~, sort_id_ratio] = sortrows(ratio(:,1));
figure(1)
plot(ratio(sort_id_ratio,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 2000')

id_max= Gi(:,1)==max(Gi(:,1)); 
plotGi = Gi;
plotGi(id_max,1)=NaN;
plotGi = plotGi/10e+9; 
[~, sort_id_Gi] = sortrows(plotGi(:,1),'ascend');

figure(2)
plot(Gi(:,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Unsorted and include outlier')
title('Derivative Gi for day 2000')

figure(3)
plot(plotGi(sort_id_Gi,1),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',20)
legend('Sorted and remove outlier')
title('Derivative Gi for day 2000')

%Plot day 4000

[~, sort_id_ratio] = sortrows(ratio(:,2));
figure(4)
plot(ratio(sort_id_ratio,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_ratio),'FontSize',20)
title('Derivative ratio for day 4000')

id_max= Gi(:,2)==max(Gi(:,2)); 
plotGi = Gi;
plotGi(id_max,2)=NaN;
plotGi = plotGi/10e+29; 
[~, sort_id_Gi] = sortrows(plotGi(:,2),'ascend');

figure(5)
plot(Gi(:,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var,'FontSize',20)
legend('Unsorted and include outlier')
title('Derivative Gi for day 4000')

figure(6)
plot(plotGi(sort_id_Gi,2),'-*','LineWidth',2);
set(gca,'XTick',1:K,'XTickLabel',Parameter_var(sort_id_Gi),'FontSize',20)
legend('Sorted and remove outlier')
title('Derivative Gi for day 4000')