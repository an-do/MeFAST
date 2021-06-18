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
%% Parameters ranges and model outputs are stored in Parameter_settings 
clear; close all; clc; 
warning('off');

parpool %parfor parpool 
tic
%% 
% First of all, we need to load all the model parameter variables set-up. 


Parameter_settings;
time_points=[25, 50]; %time points of interest in days 
%% 
% Sobol method requries us to generate 2 random matrix A and B (N/2, Np) where 
% N/2 is the number of rows for each matrix and Np is the number of parameters. 
% With that in mind, N must be even. 

Np = length(pmin); % number of parameters
y_var = 1; % model outcome of interest

N=400000; %total number of rows of 2 random matrix A and B 
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


% BAi matrices formed by all columns of B except the k column, 
% which comes from A
BAi = cell(1,Np);

for k = 1:Np
    BAi{k} = B;
    BAi{k}(:,k) = A(:,k);
end

% ABi matrices formed by all colums of A except the k column, which comes from B
ABi = cell(1,Np);
for k = 1:Np
    ABi{k} = A;
    ABi{k}(:,k) = B(:,k);
end

%% Simulate the model output for every row of matrix A, B, ABi and BAi
% at a particular time_point of interest of a particular y variable 
% taking viral load as analysis metrics 
mat = [A; B]; 
Y = zeros(N,length(time_points)); 

Nfail = 0; 
disp('Start simulating model for matrix A and B')

parfor run_num=1:N %parfor
%-------------------solve ODE-------------------%  
f=@ligandOde;
%%Initial condition and time span is stated in Parameter_settings;
y0 = [0.1,0.003,0];

%% TIME SPAN OF THE SIMULATION
t_end=50; % length of the simulations
tspan=(0:0.5:t_end);

%% Solver will quit if taking more than 100 seconds 
opts    = odeset('Events', @complexevent,'AbsTol',10^(-6)); % add AbsTol option
[t,y,te,~,~]= ode15s(@(t,y)f(t,y,mat,run_num),tspan,y0,opts);


% In the event of imaginary model outcome detects
% Tumor cells = 0  adding noise with uniform
% distribution [10^-8, 10^-6]  from te until the end 
% NK cells and T cells solution is calculated using closed form
% solution 
% N(t) = e/f + CN * exp(-f*t)
% L(t) = exp(-m*t) + CL
% where CN = exp(f*te) * (Ne- e/f);
% CL = Le -exp(-m*te)
        
if ~isempty(te) % event detected 
    t(end) = []; 

    rmin=10^(-8);
    rmax=10^(-6);
    nT = length(length(t)+1:length(tspan));

    % adding noise with uniform
    %distribution [10^-8, 10^-6] 

    y(length(t)+1:length(tspan),1)=rmin+rand(nT,1)*(rmax-rmin);

    teve = t(end); 
    Ne = y(length(t)-1,2); 
    Le = y(length(t)-1,3); 

    m = mat(run_num,12);
    e= mat(run_num,5);
    fpar = mat(run_num,7);

    CN = exp(fpar*teve)*(Ne-e/fpar);
    CL = Le -exp(-m*te);

    %concatenate NK killer using closed form solution 
    y(length(t):length(tspan),2) =  e/fpar + CN*exp(-fpar*...
        tspan(length(t):length(tspan)));
    y(length(t):length(tspan),3) =  exp(-m*...
        tspan(length(t):length(tspan)))+CL;
end

Y(run_num,:) = [y(tspan==time_points(1),y_var)...
                     y(tspan==time_points(2),y_var)];



end %run_num=1:N

Vtot=var(Y); % total variance 
%% Calculate the mean and unconditional variance of the model output 

YA = Y(1: N/2,:); 
YB= Y(N/2+1:end,:);
 
 S_vec = zeros(Np,length(time_points)); 
 ST_vec = S_vec;
 
disp('Start simulating model for matrix ABi and BAi') 

parfor k = 1:Np% parfor

    disp(['Simulate for parameter ', num2str(k), ' out of ',...
    num2str(Np), ' parameters'])

    YABi = zeros(N/2,length(time_points)); 
    YBAi = YABi;
    
    for run_num=1:N/2 %loop over row of matrix 
       
        f=@ligandOde; 
        %%Initial condition and time span is stated in Parameter_settings;
        y0 = [0.1,0.003,0];

        %% TIME SPAN OF THE SIMULATION
        t_end=50; % length of the simulations
        tspan=(0:0.5:t_end);
        opts    = odeset('Events', @complexevent,'AbsTol',10^(-6)); % add AbsTol optio
    %======== Simulate for model output for each row of matrix BAi  
       
        [t,y,te,~,~]= ode15s(@(t,y)f(t,y,BAi{k},run_num),tspan,y0,opts);
        
        % In the event of imaginary model outcome detects
        % Tumor cells = 0  adding noise with uniform
        % distribution [10^-8, 10^-6]  from te until the end 
        % NK cells and T cells solution is calculated using closed form
        % solution 
        % N(t) = e/f + CN * exp(-f*t)
        % L(t) = exp(-m*t) + CL
        % where CN = exp(f*te) * (Ne- e/f);
        % CL = Le -exp(-m*te)

        if ~isempty(te) % event detected 
            t(end) = []; 

            rmin=10^(-8);
            rmax=10^(-6);
            nT = length(length(t)+1:length(tspan));


            y(length(t)+1:length(tspan),1)=rmin+rand(nT,1)*(rmax-rmin);

            teve = t(end); 
            Ne = y(length(t)-1,2); 
            Le = y(length(t)-1,3); 

            m = BAi{k}(run_num,12);
            e= BAi{k}(run_num,5);
            fpar = BAi{k}(run_num,7);

            CN = exp(fpar*teve)*(Ne-e/fpar);
            CL = Le -exp(-m*te);

            %concatenate NK killer using closed form solution 
            y(length(t):length(tspan),2) =  e/fpar + CN*exp(-fpar*...
                tspan(length(t):length(tspan)));
            y(length(t):length(tspan),3) =  exp(-m*...
                tspan(length(t):length(tspan)))+CL;
        end
        
        YBAi(run_num, :) = [y(tspan==time_points(1),y_var)...
                     y(tspan==time_points(2),y_var)];
                 
%--- Simulating model output for each row of matrix ABi
         
         [t,y,te,~,~]= ode15s(@(t,y)f(t,y,ABi{k},run_num),tspan,y0,opts);
       
         % In the event of imaginary model outcome detects
        % Tumor cells = 0  adding noise with uniform
        % distribution [10^-8, 10^-6]  from te until the end 
        % NK cells and T cells solution is calculated using closed form
        % solution 
        % N(t) = e/f + CN * exp(-f*t)
        % L(t) = exp(-m*t) + CL
        % where CN = exp(f*te) * (Ne- e/f);
        % CL = Le -exp(-m*te)

        if ~isempty(te) % event detected 
            t(end) = []; 

            rmin=10^(-8);
            rmax=10^(-6);
            nT = length(length(t)+1:length(tspan));


            y(length(t)+1:length(tspan),1)=rmin+rand(nT,1)*(rmax-rmin);

            teve = t(end); 
            Ne = y(length(t)-1,2); 
            Le = y(length(t)-1,3); 

            m = ABi{k}(run_num,12);
            e= ABi{k}(run_num,5);
            fpar = ABi{k}(run_num,7);

            CN = exp(fpar*teve)*(Ne-e/fpar);
            CL = Le -exp(-m*te);

            %concatenate NK killer using closed form solution 
            y(length(t):length(tspan),2) =  e/fpar + CN*exp(-fpar*...
                tspan(length(t):length(tspan)));
            y(length(t):length(tspan),3) =  exp(-m*...
                tspan(length(t):length(tspan)))+CL;
        end
        
        YABi(run_num, :) = [y(tspan==time_points(1),y_var)...
                     y(tspan==time_points(2),y_var)];

    end %runnum
    
    disp(['Compute variance for parameter p',num2str(k)])
    
    Vi =  mean(YB.*(abs(YABi(:,:)-YA)));
    VTi = mean( (YA- YABi(:,:)).^2)/2;
    
    S_vec(k,:) = Vi./Vtot;
    ST_vec(k,:) = VTi./Vtot;

    

end

save('Sobol_Cancer_data.mat','S_vec','ST_vec');
time= toc;



%% 
% Make sure to turn off parpool at the end 

delete(gcp('nocreate'))
