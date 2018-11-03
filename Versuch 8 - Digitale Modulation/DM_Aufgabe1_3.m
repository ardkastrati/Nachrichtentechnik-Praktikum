% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 9 - Digitale Modulation
%
%   Aufgabe 1: Spektra verschiedener Modulationsarten
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all;

%% Parameters
% modulation parameters
M = [8,16];         % Size of signal constellation

% tx filter parameters
nsamp = 4;      % Oversampling rate
rolloff = 0;
filtorder = 40;

for i = 1:length(M)
    k = log2(M(i));   % Number of bits per symbol
    n = 6e4;       % Number of bits to process


    %% Signal Source
    % Create a binary data stream as a column vector.
    x = randi([0 1], n, 1);   % Random binary data stream
    % Bit-to-Symbol Mapping
    y = bits_to_symbols(x, M(i));


    %% Transmit Filter
    % tx filter
    clear ytx
    ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);
    periodogram(ytx);
    hold on
end
    
%% Spectrum
%figure;

 %[pxx, f] = periodogram(ytx);
 %plot(f,10*log10(pxx),'--')
