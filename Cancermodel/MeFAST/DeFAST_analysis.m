
% 
% % %% User input
function [S, id] = DeFAST_analysis(filename,alpha, type,y_var,time_id)
disp(['Compiling DeFAST result for ',type])

%% Load mat file 
%input: filename = rangeSi.mat
%       alpha = significant level e.g 0.05 (= 5%)
%       type = either first order sensitivity index (Si)
                %or total order sensitivity index (Sti)
%       yvar = output variable of interest in the order defined in the ODE
%       model   
 load(filename);
%% Input for post processing efast simulation 
Parameter_settings;
[NR, time, K, num_y_var] = eval(['size(range',type,')']); 

% Extract sensitivity indices for each parameter

for i = 1: K
    par{i} = eval(['range',type,'(:,time_id,i,y_var)']);
end 



%% Using Komogorof statistics to as convergence measures
% Using built-in matlab function kstest2

dist = zeros(NR-2,K);
disp('Measuring convergence')

for i =1:K % loop over parameter
    for n = 3:NR-1 % loop over NR= 3:49. 
                %when NR is too small, not much statistics
                % to work with
    [h(n-2,i),p(n-2,i),dist(n-2,i)]= eval(['kstest2(range',type,'(1:n,',num2str(time_id),',i,',...
         num2str(y_var),'),','range',type,'(1:n+1,',num2str(time_id),',i,',...
         num2str(y_var),'))']);
     
    end 
end




%% --------- Hypothesis tesing ------------- %
% using student t-test, wilcoxon and permutation test 
% track number of significant parameters 
% track p-values as function of resampling size NR


%allocation
n_welch = zeros(1,NR-9);
n_wilcox = n_welch;
n_permute = n_wilcox; 
n_ANOVA=n_wilcox;

id_welch = zeros(K,NR-9); 
id_wilcox = id_welch; 
id_permute = id_wilcox;


disp('Performing hypothesis testing')

for j = 5:NR % loop over NR
    j-4
    
    %====== Perform ANOVA and Tukey test ===========%
    Sti = eval(['squeeze(range',type,'(1:j,time_id,:,',num2str(y_var),'))']); %extract some data from the SI indices 
    Sti_dat = reshape(Sti',1,numel(Sti)); %
    group = reshape(repmat(Parameter_var,1,j),1,numel(Sti));

    %Apply 1 factor ANOVA and Tukey comparison test 
    [p(j),t,stats] = anova1(Sti_dat,group,'off'); % store p-value for ANOVA
    [c,m,h,nms] = multcompare(stats);
    
    
    % find number of parameter whose mean is significantly different from
    % the dummy parameter 
    n_ANOVA(j-4) = sum((c(:,2)==K) + (c(:,6)<alpha)==2); 
    
    %====================================================
    for i = 1:K-1 %loop over all parameters
    sens_par = par{i}(1:j); %parameter    
    dummy = par{K}(1:j); %dummy paramter
   
    %student t-test 
    [welch(i,j-4), p_welch(i,j-4) ] = ttest2(sens_par,dummy,alpha/K,...
        'right','unequal');
    
    %wiloxon test
    [p_wilcox(i,j-4), wilcox(i,j-4)] = ranksum(sens_par,dummy,...
        'alpha',alpha/K,'tail','right');
    
    %permutation test
    p_permute(i,j-4) = permutationTest(sens_par, dummy,1000,...
        'plotresult', 0);
     end % end i
   
   % number of significant parameters 
   
   n_welch(j-4) = sum(welch(:,j-4));
   n_wilcox(j-4) = sum(wilcox(:,j-4)); 
   n_permute(j-4) = sum(p_permute(:,j-4)<alpha/K); 
   
   %sort in in descending order
   sort_efast= eval(['squeeze(mean(range',type,'(1:j,1,:,',num2str(time_id),')))']);
   [S, id]= sort(sort_efast,'descend');
   
  
    id_welch(1:n_welch(j-4),j-4) = id(1:n_welch(j-4));
    id_wilcox(1:n_wilcox(j-4),j-4) = id(1:n_wilcox(j-4));
    id_permute(1:n_permute(j-4),j-4) = id(1:n_permute(j-4));
   
   
end %end j



%% ------ Bar plot of Average sensitivity index -------- %
mean_S= eval(['squeeze(mean(range',type,'(:,1,:,',num2str(time_id),')))']);
[S, id]= sort(mean_S,'descend');




%% ----- Bar plot of p-values ---------% 
id(id==K) = []; %remove dummy parameters from plotting


p_ANOVA= c(c(:,2)==K,6); %pvalues from ANOVA/Tukey test
barcombine = [p_welch(id,end),p_wilcox(id,end),p_permute(id) p_ANOVA(id)];



%% ---- Figure 
fsz = 20; 

%========= Generate color scheme for the pie chart =========%
mat = rand(K,3); 


figure
subplot(2,2,1)
plot(dist,'-','LineWidth',3)
set(gca, 'FontSize',fsz)
xlabel(' NR')
ylabel({'Distribution',' Distance'})
legend(Parameter_var)

% number of signifcant parameters plot 
subplot(2,2,3) 
hold on
plot(n_welch,'blue-','LineWidth',2); 
%hold on; 
plot(n_wilcox,'green','LineWidth',2);
%hold on; 
plot(n_permute,'black','LineWidth',2); 
plot(n_ANOVA,'red','LineWidth',2); 
legend('Student t-test', 'Wilcoxon', 'Permute test','ANOVA-Tukey')
%     [0.75 0.85 0.01 0.01])
set(gca, 'FontSize',fsz)
ylim([1,K])
xlabel('NR')
ylabel({ '# significant', 'parameters'})

subplot(2,2,4)
bar(barcombine, 'grouped')
xticks([1:K-1]); 
xticklabels(Parameter_var(id))
ylabel([type, ' p-values'])
set(gca, 'FontSize',fsz)
legend('Student t-test', 'Wilcoxon', 'Permutation','ANOVA-Tukey')

par = Parameter_var(1:K-1);
S_plot = S(1:K-1);

subplot(2,2,2)
ax = gca(); 
h= pie(S_plot,par(id));
set(findobj(h,'type','text'),'fontsize',20);
newColors = rand(K,3); 
ax.Colormap = newColors; 


end




