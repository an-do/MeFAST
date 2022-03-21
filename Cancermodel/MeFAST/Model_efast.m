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

% Input: 
%       NR number of resampling curve 
%       [pmin pmax]: range of parameter which can be found in
%       Parameter_setting_EFAST_Marino file 
% Output: 
%         rangeSi: distribution of Si 
%         rangeSti: distribution of Sti

function [rangeSi, rangeSti] = Model_efast(NR,pmin,pmax,time_points,myfun)

% load parameter ranges and number of model outputs of interest
Parameter_settings;
K = size(pmax,1); % # of input factors (parameters varied) + dummy parameter
n_var = length(y_var_label); % number of dependent variables
MI = 4; %: maximum number of fourier coefficients



%% Sensitivity indices 
% rangeSi, rangeSti store the history of all sensitivity indices 
% over all NR search curve 

if n_var ==1 %if only interest in 1 y-variable 
  rangeSi = zeros(NR, length(time_points),length(pmin)); 
  rangeSti = zeros(NR, length(time_points),length(pmin));
  
elseif n_var >1 %if interest in more than 1 y-variable 
  rangeSi = zeros(NR, length(time_points),length(pmin),n_var); 
  rangeSti = zeros(NR, length(time_points),length(pmin),n_var); 

end 
 
  
  
%% Compute Sensitivity index


for i=1:K % Loop over k parameters (input factors)
 disp(['Simulating DeFAST sensitivivity indices for parameter ',...
     num2str(i),' out of ', num2str(K)])

    
    % i=# of replications (or blocks)
    % Algorithm for selecting the set of frequencies.
    % OMci(i), i=1:k-1, contains the set of frequencies
    % to be used by the complementary group.
    rng(i); 
    FI_mat=rand(NR,K); %set seed 
    

    
%%  Allocation for variance computation
if n_var ==1
     Vi = zeros(NR,length(time_points));
     Vci = zeros(NR,length(time_points));
     V = zeros(NR,length(time_points));
elseif n_var > 1
    Vi = zeros(NR,length(time_points),n_var);
    Vci = zeros(NR,length(time_points),n_var);
    V = zeros(NR,length(time_points),n_var);
end

   
     for L=1:NR % Loop over the NR search curves.
         
         %% Update NS & OMi
         % Write a little routine to use Saltelli to check the condition
         NS = L*65;  
         % See Saltelli 1999 for algorithm 
        OMi = (NS/L-1)/(2*MI); 
        OM = SETFREQ(K,OMi/2/MI); % complementary frequency
        OM(i) = OMi; 
        
        %Debug: use the same random number for phase shift here 
        %FI = rand(1,K)*2*pi; % random phase shift
        
        FI = FI_mat(L,:)*2*pi; 
        S_VEC = pi*(2*(1:NS)-NS-1)/NS; % try changing it to pi/2
        OM_VEC = OM(1:K);
        FI_MAT = FI(ones(NS,1),1:K)';
        ANGLE = OM_VEC'*S_VEC+FI_MAT;
        
        X = 0.5+asin(sin(ANGLE'))/pi; % between 0 and 1
        
        % Transform distributions from standard
        % uniform to general.
        
        mat = parameterdist(X,pmax,pmin,0,1,NS,'unif'); 
        
        % Ytemp:matrix whose row is the number of simulation and number of
        % columns corresponding with model output at each time_points
        Ytemp = zeros(NS, length(time_points)*n_var); 
        
        % Simulate model NS times
         parfor run_num=1:NS %parfor 
            %-------------------solve ODE-------------------%  
            f=myfun;
             
            %%Initial condition and time span is stated in Parameter_settings;
             y0 = [0.1,0.003,0];

            %% TIME SPAN OF THE SIMULATION
            t_end=50; % length of the simulations
            tspan=(0:0.5:t_end);
            
            %%
            opts    = odeset('Events', @complexevent,'AbsTol', 1e-6);
            [t,y,te,~,~]=ode15s(@(t,y)f(t,y,mat,run_num),tspan,y0,opts);
           
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
                      
                y(length(t)+1:length(tspan),1)=...
                    rmin+rand(nT,1)*(rmax-rmin);


                teve = t(end); 
                Ne = y(length(t)-1,2); 
                Le = y(length(t)-1,3); 

                m = mat(run_num,12);
                e= mat(run_num,5);
                fpar = mat(run_num,7);
                
            % Calulate NK cells and T cells using closed form solution 
                CN = exp(fpar*teve)*(Ne-e/fpar);
                CL = Le -exp(-m*te);

            %concatenate simulated solution with closed form solution 
            y(length(t):length(tspan),2) =  e/fpar + CN*exp(-fpar*...
                tspan(length(t):length(tspan)));
            y(length(t):length(tspan),3) =  exp(-m*...
                tspan(length(t):length(tspan)))+CL;
            else 
            end
            

            
            Ytemp(run_num,:) = [y(tspan==time_points(1),:)...
                     y(tspan==time_points(2),:)]; 
            

          end %run_num=1:N
     
 
     % Case 1: model only track data of 1 type of model outcome 
     if n_var ==1
         % post processing data
         Y = Ytemp; 
         % remove any NaN entries
         Y(isnan(Y))=[];
         % Compute variance        
        for u= 1:length(time_points)
            [Vci(L,u), Vi(L,u), V(L,u)] = compute_variance(Y(:,u),OMi,MI);          
        end
        
     %Case 2: model tracks data of more than 1 types of mode outcomes
     elseif n_var >1
         
      %post processing data 
      %Y is a structure that store time data of each model output 
        Y = zeros(NS, length(time_points),n_var);           
         
        for yvar = 1:n_var %loop over y variable
            %re-arange y-data into structure  
             Y(:,:,yvar) = Ytemp(:,yvar:n_var:end);             
            
             for u= 1:length(time_points)%loop over time_points
             %compute variance
                [Vci(L,u,yvar), Vi(L,u,yvar), V(L,u,yvar)] =...
                compute_variance(Y(:,u,yvar),OMi,MI);
                rangeSi(L,u,i,yvar)= Vi(L,u,yvar)/V(L,u,yvar);
                rangeSti(L,u,i,yvar)= 1-(Vci(L,u,yvar)/V(L,u,yvar));
            end %end time_points
            
         end %end y-varibale
     end
   
     end % L=1:NR
        
  save('efast_Cancer_data.mat','rangeSi', 'rangeSti');
 


        
end % i=1:k


end
