function [b,a] = ShelvingFilter(fs,G,type,lowCutoff,highCutoff)
% DESCRIPTION:
% This function calculates the denominator and numerator coefficients of 
% the transfer function for a Shelf filter defined by the required sampling
% frequency, gain and type of the filter. The cutoff frequency is fixed at
% 200Hz for low shelf and 5kHz for high shelf. The final b & a coefficients
% are approximated to the value 1 in the case of nearly flat response so as
% to avoid any errors with the usage of invfreqz function.
% 
% INPUTS:
% fs - sampling frequency
% G - gain of the filter
% type - type of the filter (Low for low shelf, or High for high shelf)
% 
% OUTPUTS:
% b - numerator coefficients of transfer function of filter
% a - denominator coefficients of transfer function of filter

% Approximation taken to avoid error in determining transfer function
% coefficients of created final equalizer filter
if abs(G) <= 0.01
    b = 1;
    a = 1;
else
    if (strcmp(type,'Low'))
        K = tan(pi*lowCutoff/fs);
    else
        K = tan(pi*highCutoff/fs);
    end
    V0 = 10^(G/20);
    if (G>=0 && strcmp(type,'Low'))
    % Low Boost
        b0 = (1+sqrt(2*V0)*K+V0*K^2)/(1+sqrt(2)*K+K^2);
        b1 = 2*(V0*K^2-1)/(1+sqrt(2)*K+K^2);
        b2 = (1-sqrt(2*V0)*K+V0*K^2)/(1+sqrt(2)*K+K^2);
        a1 = 2*(K^2-1)/(1+sqrt(2)*K+K^2);
        a2 = (1-sqrt(2)*K+K^2)/(1+sqrt(2)*K+K^2);

    elseif (G<0 && strcmp(type,'Low'))
    % Low Cut
        b0 = V0*(1+sqrt(2)*K+K^2)/(V0+sqrt(2*V0)*K+K^2);
        b1 = 2*V0*(K^2-1)/(V0+sqrt(2*V0)*K+K^2);
        b2 = V0*(1-sqrt(2)*K+K^2)/(V0+sqrt(2*V0)*K+K^2);
        a1 = 2*(K^2-V0)/(V0+sqrt(2*V0)*K+K^2);
        a2 = (V0-sqrt(2*V0)*K+K^2)/(V0+sqrt(2*V0)*K+K^2);

    elseif (G>=0 && strcmp(type,'High'))
    % High Boost
        b0 = (V0+sqrt(2*V0)*K+K^2)/(1+sqrt(2)*K+K^2);
        b1 = 2*(K^2-V0)/(1+sqrt(2)*K+K^2);
        b2 = (V0-sqrt(2*V0)*K+K^2)/(1+sqrt(2)*K+K^2);
        a1 = 2*(K^2-1)/(1+sqrt(2)*K+K^2);
        a2 = (1-sqrt(2)*K+K^2)/(1+sqrt(2)*K+K^2);

    else
    %High Cut
        b0 = V0*(1+sqrt(2)*K+K^2)/(1+sqrt(2*V0)*K+V0*K^2);
        b1 = 2*V0*(K^2-1)/(1+sqrt(2*V0)*K+V0*K^2);
        b2 = V0*(1-sqrt(2)*K+K^2)/(1+sqrt(2*V0)*K+V0*K^2);
        a1 = 2*(V0*K^2-1)/(1+sqrt(2*V0)*K+V0*K^2);
        a2 = (1-sqrt(2*V0)*K+V0*K^2)/(1+sqrt(2*V0)*K+V0*K^2);

    end
    a = [1, a1, a2];
    b = [b0, b1, b2];
end

end