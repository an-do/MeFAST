% load('LHS.csv'); 
% load('sens_mat.csv'); 

Parameter_settings;
time_point =[25,50]; 

k = size(Parameter_var,1);
step= 1000;
N=size(sens_mat,1);
Nrow = round(N/step);

ave_sens = zeros(Nrow-1,k,length(time_point)); 
std_sens = ave_sens;
ratio = ave_sens;
Gi = ave_sens;

for j = 1: Nrow-1
    %calculate mean and standard deviatio
    ave_sens(j,:,:) = mean(abs(sens_mat(1:j*step,:,:)));
    std_sens(j,:,:) = std(abs(sens_mat(1:j*step,:,:)));
    
    % ratio mean/std
    ratio(j,:,:) = ave_sens(j,:,:)./std_sens(j,:,:);
    %[~,id(j,:)] = sortrows(ratio(j,:)','descend');
    
    % Gi = mean^2 + std^2
    Gi(j,:,:) = ave_sens(j,:,:).^2 + std_sens(j,:,:).^2;
    %[~,id_Gi(j,:)] = sortrows(Gi(j,:)','descend');

    % rank agreement for both measures
%     if j > 1 
%        TDCC(j) = isequal(id(j-1,:),id(j,:));
%        TDCC_Gi(j) = isequal(id_Gi(j-1,:),id_Gi(j,:));
%     end 
    
end

%--------------------- Day 25

figure; 
fntsz = 15; 
subplot(2,2,[1 2])
bar(ratio(end,:,1),0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel(['Mean/Std at ',num2str(time_point(1)),' days'])
set(gca, 'FontSize',fntsz)

% subplot(2,2,2)
% plot(Gi(end,id_Gi(end,:)),0.6)
% xticks([1:k]); 
% xticklabels(Parameter_var(id_Gi(end,:)))
% set(gca, 'FontSize',fntsz)
% ylabel('Gi')

subplot(2,2,[3 4])
bar(Gi(end,:,1),0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel(['Gi at ',num2str(time_point(1)),' days'])
set(gca, 'FontSize',fntsz)

%--------------------- Day 25

figure; 
fntsz = 15; 
subplot(2,2,[1 2])
bar(ratio(end,:,2),0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel(['Mean/Std at ',num2str(time_point(2)),' days'])
set(gca, 'FontSize',fntsz)

% subplot(2,2,2)
% plot(Gi(end,id_Gi(end,:)),0.6)
% xticks([1:k]); 
% xticklabels(Parameter_var(id_Gi(end,:)))
% set(gca, 'FontSize',fntsz)
% ylabel('Gi')

subplot(2,2,[3 4])
bar(Gi(end,:,2),0.6)
xticks([1:k]); 
xticklabels(Parameter_var)
ylabel(['Gi at ',num2str(time_point(2)),' days'])
set(gca, 'FontSize',fntsz)

