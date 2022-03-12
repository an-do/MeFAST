function [S, id] = DeFAST_analysis(filename,alpha, type,y_var,time_id)

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


for i = 1: K
    par{i} = eval(['range',type,'(:,time_id,i,y_var)']);
end 



%% Check Kullback distance for convergence 
% Sturge's rule for number of bin 1 + log(n)/log(2)

dist = zeros(NR-2,K);
for i =1:K % loop over parameter
    for n = 3:NR-1 % loop over NR= 3:49. 
                %when NR is too small, not much statistics
                % to work with
%     eval([type,'_n=range',type,'(1:n,',num2str(time_id),',i,',...
%         num2str(y_var),');']);
%     eval([type,'_N=range',type,'(1:n+1,',num2str(time_id),',i,',...
%         num2str(y_var),');']);
%     hist_n = hist(eval([type,'_n']),1+ log(n)/log(2)); 
%     hist_N= hist(eval([type,'_N']),1+log(n)/log(2)); 
%     dist(n-2,i) = KLDiv(hist_n, hist_N);
    [h(n-2,i),p(n-2,i),dist(n-2,i)]= eval(['kstest2(range',type,'(1:n,',num2str(time_id),',i,',...
         num2str(y_var),'),','range',type,'(1:n+1,',num2str(time_id),',i,',...
         num2str(y_var),'))']);
     
    end 
end




%% --------- Hypothesis tesing ------------- %
% using student t-test, wilcoxon and permutation test 
% track number of significant parameters 
% track p-values as function of resampling size NR

n_welch = zeros(1,NR-9);
n_wilcox = n_welch;
n_permute = n_wilcox; 
n_ANOVA=n_wilcox;

id_welch = zeros(K,NR-9); 
id_wilcox = id_welch; 
id_permute = id_wilcox;

for j = 10:NR % loop over NR
    j-9
    
    %====== Perform ANOVA and Tukey test ===========%
    Sti = eval(['squeeze(range',type,'(1:j,time_id,:,',num2str(y_var),'))']); %extract some data from the SI indices 
    Sti_dat = reshape(Sti',1,numel(Sti)); %
    group = reshape(repmat(Parameter_var,1,j),1,numel(Sti));

    %Apply 1 factor ANOVA and Tukey comparison test 
    [p(j),t,stats] = anova1(Sti_dat,group,'off'); % store p-value for ANOVA
    [c,m,h,nms] = multcompare(stats);
    
    
    % find number of parameter whose mean is significantly different from
    % the dummy parameter 
    n_ANOVA(j-9) = sum((c(:,2)==K) + (c(:,6)<alpha)==2); 
    
    %====================================================
    for i = 1:K-1 %loop over all parameters
    sens_par = par{i}(1:j); %parameter    
    dummy = par{K}(1:j); %dummy paramter
   
    %student t-test 
    [welch(i,j-9), p_welch(i,j-9) ] = ttest2(sens_par,dummy,alpha/K,...
        'right','unequal');
    
    %wiloxon test
    [p_wilcox(i,j-9), wilcox(i,j-9)] = ranksum(sens_par,dummy,...
        'alpha',alpha/K,'tail','right');
    
    %permutation test
    p_permute(i,j-9) = permutationTest(sens_par, dummy,1000,...
        'plotresult', 0);
     end % end i
   
   % number of significant parameters 
   
   n_welch(j-9) = sum(welch(:,j-9));
   n_wilcox(j-9) = sum(wilcox(:,j-9)); 
   n_permute(j-9) = sum(p_permute(:,j-9)<alpha/K); 
   
   %sort in in descending order
   sort_efast= eval(['squeeze(mean(range',type,'(1:j,1,:,4)))']);
   [S, id]= sort(sort_efast,'descend');
   
  
    id_welch(1:n_welch(j-9),j-9) = id(1:n_welch(j-9));
    id_wilcox(1:n_wilcox(j-9),j-9) = id(1:n_wilcox(j-9));
    id_permute(1:n_permute(j-9),j-9) = id(1:n_permute(j-9));
   
%     if j>10
%         TDCC_welch(j-10) = isequal(id_welch(:,j-10),id_welch(:,j-9));
%         TDCC_wilcox(j-10) = isequal(id_wilcox(:,j-10),id_wilcox(:,j-9));
%         TDCC_permute(j-10) = isequal(id_permute(:,j-10),id_permute(:,j-9));
%     end
   
end %end j



%% ------ Bar plot of Average sensitivity index -------- %
mean_S= eval(['squeeze(mean(range',type,'(:,1,:,4)))']);
std_S= eval(['squeeze(std(range',type,'(:,1,:,4)))']);

[S, id]= sort(mean_S,'descend');




%% ----- Bar plot of p-values ---------% 
id(id==K) = [];

p_ANOVA= c(c(:,2)==9,6);
barcombine = [p_welch(id,end),p_wilcox(id,end),p_permute(id) p_ANOVA(id)];



%% ---- Figure 
fsz = 20; 

%========= Generate color scheme for the pie chart =========%
mat = [0.5587    0.1129    0.4465;
    0.6322    0.1846    0.7316;
    0.5097    0.7352    0.6155;
    0.0015    0.0009    0.8960;
    0.8734    0.1453    0.5739;
    0.8889    0.8124    0.9164;
    0.9822    0.5704    0.3287;
    0.7344    0.6793    0.4660;
    0.8466    0.8063    0.6418;
    0.6858    0.6516    0.9520;
    0.6633    0.4060    0.4424;
    0.8100    0.5572    0.3042;
    0.1988    0.8956    0.6482;
    0.2983    0.7561    0.4557;
    0.4843    0.4545    0.5705;
    0.7767    0.8708    0.2977;
    0.2439    0.0556    0.6147;];


figure
plot(dist,'-','LineWidth',3)
set(gca, 'FontSize',fsz)
xlabel(' NR')
ylabel({'Distribution',' Distance'})
legend(Parameter_var)

% number of signifcant parameters plot 
figure
hold on
plot(n_welch,'blue-','LineWidth',2); 
hold on; 
plot(n_wilcox,'green','LineWidth',2);
hold on; 
plot(n_permute,'black','LineWidth',2); 
plot(n_ANOVA,'red','LineWidth',2); 
legend('Student t-test', 'Wilcoxon', 'Permute test','ANOVA-Tukey')
%     [0.75 0.85 0.01 0.01])
set(gca, 'FontSize',fsz)
ylim([1,K])
xlabel('NR')
ylabel({ '# significant', 'parameters'})

figure 
bar(barcombine, 'grouped')
xticks([1:K-1]); 
xticklabels(Parameter_var(id))
ylabel([type, ' p-values'])
set(gca, 'FontSize',fsz)
legend('Student t-test', 'Wilcoxon', 'Permutation','ANOVA-Tukey')

par = Parameter_var(1:K-1);
S_plot = S(1:K-1);

figure
ax = gca(); 
h= pie(S_plot,par(id));
set(findobj(h,'type','text'),'fontsize',20);
newColors = rand(K,3); 
ax.Colormap = newColors; 


end


