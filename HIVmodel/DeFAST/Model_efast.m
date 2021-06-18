% Input: NR number of resampling curve 
%       [pmin pmax]: range of parameter which can be found in
%       Parameter_setting_EFAST_Marino file 
% Output: Si, Sti: average sensitvity index 
%         rangeSi: distribution of Si 
%         rangeSti: distribution of Sti

function [rangeSi, rangeSti] = Model_efast(NR,pmin,pmax,time_points,myfun)

% load parameter ranges and number of model outputs of interest
Parameter_settings;
K = size(pmax,1); % # of input factors (parameters varied) + dummy parameter
n_var = length(y_var_label); % number of dependent variables
MI = 4; %: maximum number of fourier coefficients


%% Marino: eFAST set-up: 

% %Check for the eFAST requirements of NS and NR 
% wantedN=NS*K*NR; % wanted no. of sample points
% 
% OMi = floor(((wantedN/NR)-1)/(2*MI)/K);
% % can be written as 
% % OMI = floor(NS/(2*MI)- 1/K);
% 
% %OMi = (NS/NR-1)/(2*MI);
% NS = 2*MI*OMi+1; % classic eFAST formula
%                  % Saltelli 1999 equation 15
% 
% % This flag does not meet eFAST criteria  
% if(NS*NR < 65)
%     fprintf(['Error: sample size must be >= ' ...
%     '65 per factor.\n']);
%     return;
% end



%% Sensitivity indices 
% rangeSi, rangeSti store the history of all sensitivity indices 
% over all NR search curve 

if n_var ==1 %if only interest in 1 y-variable 
  rangeSi = zeros(NR, length(time_points),length(pmin)); 
  rangeSti = zeros(NR, length(time_points),length(pmin));
  Si = zeros(length(pmin),length(time_points));
  Sti = Si;
elseif n_var >1 %if interest in more than 1 y-variable 
  rangeSi = zeros(NR, length(time_points),length(pmin),n_var); 
  rangeSti = zeros(NR, length(time_points),length(pmin),n_var); 
  Si = zeros(length(pmin),length(time_points),n_var);
  Sti = Si;
end 
 
  
  
%% Compute Sensitivity index


for i=1:K % Loop over k parameters (input factors)
    % i=# of replications (or blocks)
    % Algorithm for selecting the set of frequencies.
    % OMci(i), i=1:k-1, contains the set of frequencies
    % to be used by the complementary group.
    disp(['Simulating parameter ', num2str(i),' out of ', num2str(K)'])
    rng(i); 
    FI_mat=rand(NR,K); %set seed 
    
%% December 10: Fixed OMi = 8 and other parameters = 1

%     OM = OMci;
%     OM(i) = OMi; %replace wt the highest frequency OMi 
    
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
        
        %%this is what assigns 'our' values rather than 0:1 dist
        mat = parameterdist(X,pmax,pmin,0,1,NS,'unif'); 
        
        % Ytemp:matrix whose row is the number of simulation and number of
        % columns corresponding with model output at each time_points
        Ytemp = zeros(NS, length(time_points)*n_var); 
        
        % Simulate model NS times
         parfor run_num=1:NS %remember to turn on for paralell computing 
          %[i run_num L] 
          %-------------------solve ODE-------------------%  
            f=myfun;
            t_end=4000; % length of the simulations
            tspan=(0:1:t_end);   % time points where the output is calculated
            %% INITIAL CONDITION FOR THE ODE MODEL
            T0=1e3;
            T1=0;
            T2=0;
            V=1e-3;

            y0=[T0,T1,T2,V];

            %% Solver will quit if taking more than 100 seconds  
            [t,y]=ode15s(@(t,y)f(t,y,mat,run_num),tspan,y0,[]);

            % save output as vector so that now we can store data as in T1D case 
            Ytemp(run_num,:) = reshape(y(time_points+1,:)',...
                [1,length(time_points)*n_var]);

          
        end %run_num=1:N
     
     
     % Case 1: model only track data of 1 type of model outcome 
     % See example as in T1D model
     if n_var ==1
         % post processing data
         Y = Ytemp;     
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
        
 save('DeFAST_HIV_data.mat','rangeSi','rangeSti');
 %save(['rangeSti_NR',num2str(NR),'.mat'],'rangeSti');



        
end % i=1:k



end
