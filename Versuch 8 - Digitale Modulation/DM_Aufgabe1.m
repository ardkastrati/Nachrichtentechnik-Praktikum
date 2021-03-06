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
M = 8;         % Size of signal constellation
k = log2(M);   % Number of bits per symbol
n = 6e4;       % Number of bits to process

% tx filter parameters
nsamp = 4;      % Oversampling rate
rolloff = [0,0.4,0.8,1];
filtorder = 40;

%% Signal Source
% Create a binary data stream as a column vector.
x = randi([0 1], n, 1);   % Random binary data stream
% Bit-to-Symbol Mapping
y = bits_to_symbols(x, M);


for i = 1:length(rolloff)
    %% Transmit Filter
    % tx filter
    ytx(:,i) = DM_tx_filter(filtorder, rolloff(i), nsamp, y);
end

%% Spectrum
%figure;
periodogram(ytx);

% [pxx, f] = periodogram(ytx);
% plot(f,10*log10(pxx),'--')

legend('r=0','r=0.4','r=0.8','r=1')