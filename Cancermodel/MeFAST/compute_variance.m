function [Vci, Vi, V] = compute_variance(Y,OMi,MI)
%input: Y= Y(:,t,i,L): glucose matrix at a given time_point
%       OMi: frequency of parameter of interest
%   Mi : maximum number of Fourier coefs in calculating partial variance
        Y = (Y- mean(Y))';
         
         % Fourier coeff. at [1:OMi/2].
         N=length(Y);
         NQ = floor((N-1)/2);
         N0 = floor(NQ+1);
         COMPL = 0;
         Y_VECP = Y(N0+(1:NQ))+Y(N0-(1:NQ));
         Y_VECM = Y(N0+(1:NQ))-Y(N0-(1:NQ));
                
         for j=1:OMi/2
                ANGLE = j*2*(1:NQ)*pi/N; % why different from S_VEC in sampling routine?
                C_VEC = cos(ANGLE);
                S_VEC = sin(ANGLE);
                AC(j) = (Y(N0)+Y_VECP*C_VEC')/N;
                BC(j) = Y_VECM*S_VEC'/N;
                COMPL = COMPL+AC(j)^2+BC(j)^2;
         end
         
         % Computation of V_{(ci)}.
            Vci = 2*COMPL;
            COMPL = 0;
            Y_VECP = Y(N0+(1:NQ))+Y(N0-(1:NQ));
            Y_VECM = Y(N0+(1:NQ))-Y(N0-(1:NQ));
                
         for j=OMi:OMi:OMi*MI
                 ANGLE = j*2*(1:NQ)*pi/N;
                 C_VEC = cos(ANGLE');
                 S_VEC = sin(ANGLE');
                 AC(j) = (Y(N0)+Y_VECP*C_VEC)/N;
                 BC(j) = Y_VECM*S_VEC/N;
                 COMPL = COMPL+AC(j)^2+BC(j)^2;
         end
         
         % Computation of V_i.
                Vi = 2*COMPL;
                %AVi = AVi+Vi;
                % Computation of the total variance
                % in the time domain.
         %Total variance
                V = Y*Y'/N;        
        end
        

