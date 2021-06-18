Sti = rangeSti(:,1,:,4); 
alpha = 0.05 ;
[NR,u, K] = size(Sti); 


for j = 30: 100
    for i = 1: K-1
        par = squeeze(Sti(:,1,i));
        dummy = squeeze(Sti(:,1,K));
        p(i) = permutationTest(par(1:j), dummy(1:j),...
            20000,'plotresult', 0);
    end 
    sig_par(j-29) = sum(p<alpha/K);
end

parameter = Parameter_var(1:8); 
pvalue= p'; 
T = table(parameter,pvalue)