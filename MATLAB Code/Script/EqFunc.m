function [h_low,h_high,h_eq,w,b,a] = EqFunc(fs,G_low,G_high, lowCutoff, highCutoff)

% DESCRIPTION:
% This function calculates the denominator and numerator coefficients of 
% the transfer function for the created equalizer which is a cascaded 
% combination of a low shelf filter with 200Hz cutoff frequency, mid peak
% filter with 1kHz center frequency and high shelf filter with 5kHz cutoff
% frequency. It takes the gains of all filters as inputs along with the
% sampling frequency. The final b & a coefficients are approximated to the
% value 1 in the case of flat response so as to avoid any errors with the
% usage of invfreqz function.
% 
% INPUTS:
% fs - sampling frequency
% G_low - gain of low shelf filter
% G_high - gain of high shelf filter
% lowCutoff - low cutoff of the low shelf
% highCutoff - high cutoff of the high shelf
% 
% OUTPUTS:
% h_low - filter response of low shelf
% h_high - filter response of high shelf
% h_eq - overall filter response of created cascaded equalizing filter
% w - angular frequency range over which filter response was calculated
% b - Numerator coefficients of transfer function of created cascaded equalizing filter
% a - Denominator coefficients of transfer function of created cascaded equalizing filter

% Calculating filter coefficients and response for low shelf
[b_low,a_low] = ShelvingFilter(fs,G_low,'Low', lowCutoff, highCutoff);
[h_low,~] = freqz(b_low,a_low,2048);

% Calculating filter coefficients and response for high shelf
[b_high,a_high] = ShelvingFilter(fs,G_high,'High', lowCutoff, highCutoff);
[h_high,~] = freqz(b_high,a_high,2048);

% Calculating created cascaded equalizing filter response and coefficients
h_eq = h_low .* h_high;
w = (0:pi/2048:pi-pi/2048)';
if h_eq(:,1) == ones(2048,1)
    b = 1;
    a = 1;
else
    [b,a] = invfreqz(h_eq,w,2,2);
end

end