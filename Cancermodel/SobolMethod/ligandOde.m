function ydot=ligandOde(t,y,LHS,run_num)
% ode file for the model derived from the paper by Raulet et al
% y = (T,N,L), where T are the tumor cells, N are the NK cells, and L are the CD8 cells
% par=[a b c(i) d(j) e eL(j)  f g(i) h  j(j)  k m p q r s(j)]; where i and j
% indicate whether we are dealing with ligand-transduced or non-transduced
% cells.
par = LHS(run_num,:);

T = y(1,:);
N = y(2,:);
L = y(3,:);
% parameters
a = par(1);  
b = par(2);  
c = par(3);  % kill rate of tumor by NK cells
d = par(4);   % kill rate of tumor by CD8 cells
e = par(5);  % constant source rate of immune cells
e_L = par(6); % exponent in tumor-CD8 competition term 
f  = par(7);  % death rate of NK cells
g = par(8);  % maximum recruitment rate of NK cells due to tumor
h = par(9);  % determines the steepness of recruitment curve of NK cells due to tumor
j=par(10); % maximum recruitment rate of CD8 cells due to tumor
k = par(11);  % determines the steepness of the CD8 recruitment curve
m=par(12);    % death rate of the CD8 cells
p=par(13); %inactivation rate of NK cells
q=par(14);  % inactivation rate of CD8 cells
r = par(15); % activation rate of antigen-specific response
s = par(16);  % constant in the denominator of the CD8 competition term

%DT=d*T.*(L./T).^(e_L)./((L./T).^(e_L)+s);
DT= (d*T.*(L).^(e_L)./((L).^(e_L)+s*T.^(e_L)));

ydot=[ a*T.*(1-b*T)-c*N.*T-DT;
       e-f*N+g*N.*T.^2./(h+T.^2)-p*N.*T;
       -m*L+j*L.*DT.^2./(k+DT.^2)-q*L.*T + r*N.*T];

% t0=0;
% tf=45;
% y0=[.1,1,.01];
% 
% par=[a b c(indexNK) d(indexCD) e eL(indexCD)  f g(indexNK) h  j(indexCD)  k m p q r s(indexCD)];
% 
% [Tstar,Ystar]=ode15s(@ligandOde,[t0 tf],y0,[],par);
