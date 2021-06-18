%% This ODE represents the HIV model in Section 4.2
function dy=ODE_model(t,y,LHS,run_num)

%% Input: 
%   LHS: matrix where the order of stored parameter values
%           is stated in parameter_setting_efast
%   t: time vector 
%   y: model output vector 
%   runnum: row of LHS matrix, simulation index. 


%% Load sampling parameters %%
par = LHS(run_num,:); %load parameter values from LHS matrix
%loadparameters; % load parameter values to the assgned names 

%load sampling parameter values 
s=par(1);
muT=par(2);
r=par(3);
k1=par(4);
k2=par(5);
mub=par(6);
N=par(7);
muV=par(8);


%Fixed parameter 
Tmax = 1500; 

%% ODE model 

%Initialize dy vector 
dy = zeros(4,1);

%Define state variables
T= y(1);
T1=y(2);
T2=y(3);
V=y(4);

% Preliminary calculation
% [T] CD4+ uninfected: Tsource + Tprolif - Tinf
Tsource = s - muT*T;
Tprolif = r*T*(1-(T+T1+T2)/Tmax);
Tinf = k1*T*V;

% [T1] CD4+ latently infected: Tinf - T1death - T1inf
T1death = muT*T1;
T1inf = k2*T1;

% [T2] CD4+ actively infected: T1inf - T2death
T2death = mub*T2;

% [V] Free infectious virus: Vrelease - Tinf - Vdeath
Vrelease = N*T2death;
Vdeath = muV*V;

%Dynamical system 
dy(1) = Tsource + Tprolif - Tinf;
dy(2)= Tinf - T1death - T1inf;
dy(3) = T1inf - T2death;
dy(4)= Vrelease - Tinf - Vdeath;

end 
