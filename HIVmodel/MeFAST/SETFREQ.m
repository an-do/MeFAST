% Algorithm for selection of a frequency
% set for the complementary group. Done
% recursively as described in:
% Appendix of "Sensitivity Analysis"
% [Saltelli et al., 2000]
%OMci = SETFREQ(k-1,OMi/2/MI) 


% sampling procedure in eFAST
% Kci: number of parameters 
% OMciMAX = maximum allowable frequency of complement set 

function OMci = SETFREQ(Kci,OMciMAX)
% Kci: number of parameters 
% OMciMAX = maximum allowable frequency of complement set 

if Kci==1
    OMci = 1;
elseif OMciMAX==1
    OMci = ones(1,Kci);
else
    if(OMciMAX < Kci)
         INFD = OMciMAX;
    else
        INFD = Kci;
    end
    
    % step between assigned frequencies 
    ISTEP = round((OMciMAX-1)/(INFD-1)); 
    
    
    if(OMciMAX == 1)
        ISTEP = 0;
    end
    OTMP = 1:ISTEP:INFD*ISTEP;
    fl_INFD = floor(INFD);
    for i=1:Kci
        j = mod(i-1,fl_INFD)+1; %parameter index
        OMci(i) = OTMP(j); % assign parameter with frequency
    end
end
%OMci(f)=[];