%% PARAMETER INITIALIZATION
% set up max and mix matrices
% parameters
% a = par(1);  
% b = par(2);  
% c = par(3);  % kill rate of tumor by NK cells
% d = par(4);   % kill rate of tumor by CD8 cells
% e = par(5);  % constant source rate of immune cells
% e_L = par(6); % exponent in tumor-CD8 competition term 
% f  = par(7);  % death rate of NK cells
% g = par(8);  % maximum recruitment rate of NK cells due to tumor
% h = par(9);  % determines the steepness of recruitment curve of NK cells due to tumor
% j=par(10); % maximum recruitment rate of CD8 cells due to tumor
% k = par(11);  % determines the steepness of the CD8 recruitment curve
% m=par(12);    % death rate of the CD8 cells
% p=par(13); %inactivation rate of NK cells
% q=par(14);  % inactivation rate of CD8 cells
% r = par(15); % activation rate of antigen-specific response
% s = par(16);  % constant in the denominator of the CD8 competition term

pmin=[
0.4885; %a
0.0921*10^(-3); %b
.0291 %c
5.22; %d
.117; % e
1.2920;%eL [ 0.58  0.46  0.90  0.75 ]
.0371; %f
.0224; %g
0.0018;  %h
0.0336; %j
0.0018;  %k
.018;  %m
.009; %p
.3080*10^(-4);	%q
.0099; %r
.225; %s
0 % dummy
];

pmax=[
0.5168; %a
.1034*10^(-3); %b
.0326 %c
5.85 %d
.1313; % e
1.3668; %eL [ 0.58  0.46  0.90  0.75 ]
.0416; %f
0.0251; %g
0.002;  %h
0.0377; %j
0.002;  %k
0.0202;  %m
0.0101; %p
.3456*10^(-4);	%q
.0111; %r
0.2525; % s
1  % dummy
]; 

% Parameter Labels 
Parameter_var={'a', 'b', 'c', ...
    'd','e','eL', 'f','g', 'h',...
    'j','k', 'm','p','q','r','s',...
    'dummy'}';%,

% PARAMETER BASELINE VALUES
baseline = [
0.51421554; %a
1.023466211*10^(-4); %b
.0323 %c or .3495
5.8 %d [ 1.43  3.60  3.51  7.17 ]
.13; % e [ 0.58  0.46  0.90  0.75 ]
1.36 %eL [ 0.58  0.46  0.90  0.75 ]
.0412; %f
.0249; %g [.1245 0.0249]
2.019*10^(-3);  %h
0.0374; %j [.1867,.747,.996]
2.019*10^(-3);  %k
.02;  %m
1.0*10^(-2); %p
3.422*10^(-5);	%q
.011; %r
.25; %s [ 2.73  1.61  5.07  0.40 ]
0.5  % dummy
];

y_var_label={'T','N','L'};

 %% INITIAL CONDITION FOR THE ODE MODEL
 y0 = [0.1,0.003,0];
     
%% TIME SPAN OF THE SIMULATION
t_end=50; % length of the simulations
t0=0;
tspan=(0:t_end);   % time points where the output is calculated


