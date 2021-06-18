%% PARAMETER INITIALIZATION
% set up max and mix matrices

pmin=[
    1e-2, % s 
1e-4, % muT
1e-3, % r
1e-7, % k1 
1e-5, % k2
1e-1, % mub
1, % N
1e-1, % muV
1]; % dummy

pmax=[50, % s 
0.2, % muT
50, % r
1e-3, % k1
1e-2, % k2
0.4, % mub
2000, % N
10, % muV
10]; % dummy

% Parameter Labels 
Parameter_var={'s', '\mu_T', 'r', ...
    'k_1','k_2', '\mu_b','N_V', '\mu_V','dummy'}';%,

% PARAMETER BASELINE VALUES
baseline = [
 10 %s
 2e-2 %muT
 0.03 %r
 2.4e-5 %k1
 3e-3 %k2
 0.24 % mub
 1200 %NV
 2.4 %muV
 1
];

y_var_label={'T','T*','T**','V'};

     
%% TIME SPAN OF THE SIMULATION
t_end=4000; % length of the simulations
tspan=(0:1:t_end);   % time points where the output is calculated

%% INITIAL CONDITION FOR THE ODE MODEL
T0=1e3;
T1=0;
T2=0;
V=1e-3;

y0=[T0,T1,T2,V];

