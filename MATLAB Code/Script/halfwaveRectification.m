% HALFWAVERECTIFICATION
% This function implements full-wave rectification
% distortion. Amplitude values of the input signal
% which are negative are changed to zero in the
% output signal.

function [out] = halfwaveRectification(in)

N = length(in);
out = zeros(N,1);
for n = 1:N
   
    if in(n,1) >= 0 
        % If positive, assign input to output
        out(n,1) = in(n,1);
    else
        % If negative, set output to zero
        out(n,1) = 0;
        
    end
    
end