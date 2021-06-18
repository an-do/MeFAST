function [ratio_out, Gi_out] = derivative_data_analysis(matfile)

%input: LHS file, sens_mat file with quotation mark 
% ex: 'LHS.csv','sens_mat.csv'

%output: mean/std, Gi
load(matfile); % should include LHS file in there

%LHS = load(LHSfile); 
%sens_mat = load(sensfile); 

Parameter_settings;
k = size(Parameter_var,1);

ave_sens = zeros(500,k); 
std_sens = ave_sens;

ratio = ave_sens;
id = ave_sens;

id_Gi = id;
Gi = ave_sens;


for j = 1: 500
    
    %calculate mean and standard deviatio
    ave_sens(j,:) = mean(abs(sens_mat(1:j*400,:)));
    std_sens(j,:) = std(abs(sens_mat(1:j*400,:)));
    
    % ratio mean/std
    ratio(j,:) = ave_sens(j,:)./std_sens(j,:);
    [~,id(j,:)] = sortrows(ratio(j,:)','descend');
    
    % Gi = mean^2 + std^2
    Gi(j,:) = ave_sens(j,:).^2 + std_sens(j,:).^2;
    [~,id_Gi(j,:)] = sortrows(Gi(j,:)','descend');
    
end

%---------------- output of function
ratio_out = ratio(end,:);
Gi_out = Gi(end,:);


%--------------------- ratio plot

figure; 
fntsz = 15; 
subplot(2,2,[1 2])
bar(ratio_out,0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel('Mean/Std')
set(gca, 'FontSize',fntsz)

% subplot(2,2,2)
% plot(Gi(end,id_Gi(end,:)),0.6)
% xticks([1:k]); 
% xticklabels(Parameter_var(id_Gi(end,:)))
% set(gca, 'FontSize',fntsz)
% ylabel('Gi')

subplot(2,2,[3 4])
plot(ratio,'*-','LineWidth',2)
xlabel('LHS size')
ylabel('Mean/Std')
legend(Parameter_var)
set(gca, 'FontSize',fntsz)

%--------------------- Gi plot 

figure; 
fntsz = 15; 
subplot(2,2,[1 2])
bar(Gi_out,0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel('Gi = mean^2 + std^2')
set(gca, 'FontSize',fntsz)

% subplot(2,2,2)
% plot(TDCC_Gi,'*-','LineWidth',2)
% set(gca, 'FontSize',fntsz)
% xlabel('LHS size (in thousands)')
% ylabel('Ranking agreement')

subplot(2,2,[3 4])
plot(Gi,'*-','LineWidth',2)
legend(Parameter_var)
set(gca, 'FontSize',fntsz)
end

