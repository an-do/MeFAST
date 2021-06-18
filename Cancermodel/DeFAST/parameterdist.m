%% Parameter distributions for eFAST sampling scheme %%
%% X: efast search curves normalized between o and 1, i.e. 
%% [X(:,:,i,L) = 0.5+asin(sin(ANGLE'))/pi;
%% [pmin pmax]: min and max values of the range of variation
%% [pmean pstd]: mean and standard deviation for distributions other than
%% uniform
%% nsample: number of samples (usually 65 in efast)
%% type: type of distributions (pdf). Uniform ['unif'], nomral ['norm'],
%% lognormal ['lognorm']
%% The uniform pdf implements a log scale for pmax/pim>1e4

function Xdist = parameterdist(X,pmax,pmin,pmean,pstd,nsample,type)
switch lower(type)
    case {'unif'}
        for k=1:length(X(1,:)) %loop through parameters
            nvar=length(pmin);
            nsample;
            ran=rand(nsample,1);
            s=zeros(nsample,1);
            idx=randperm(nsample);
            %pause;
            P =(idx'-ran)/nsample;
            %pause;
            Xdist(:,k)=(X(:,k).*(pmax(k)-pmin(k)))+pmin(k);
            
        end
    case {'norm'}
        for k=1:length(X(1,:)) %loop through parameters
            Xdist(:,k) = norminv(X(:,k),pmean(k),pstd(k));
        end
    case {'lognorm'}
        for k=1:length(X(1,:)) %loop through parameters
            Xdist(:,k) = norminv(X(:,k),log(pmean(k)),pstd(k));
        end
    otherwise
        disp('Unknown pdf')
end