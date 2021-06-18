%input: load mat file name in quotation mark
% load(filename); 

Parameter_settings;
k = length(pmin);
time_point = [25,50]; 


for u = 1:length(time_point)
    % extract data for each time_point
    [~,ids] = sortrows(S_vec(:,u),'descend');
    [~,idst] = sortrows(ST_vec(:,u),'descend');
    
    % plot 
    
    figure;
    plot(S_vec(ids,u),'*-');
    hold on
    plot(ST_vec(ids,u),'*-');
    set(gca,'XTick',[1:k],'XTickLabel',Parameter_var(ids),'FontSize',25)
    legend('First order','Total order')
    title(['Day',num2str(time_point(u)),' day'])
end 



