function [value, isterminal, direction] = complexevent(t, y)
value      = isreal(y(1));% detect imaginary values
isterminal = 1;   % Stop the integration
direction  = 0;
end