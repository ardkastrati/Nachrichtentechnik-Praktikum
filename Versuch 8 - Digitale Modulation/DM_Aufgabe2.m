% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 9 - Digitale Modulation
%
%   Aufgabe 2: St??rung durch additives wei??es Rauschen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all;

%% Setup
% Define parameters.
M = 8;          % Size of signal constellation
k = log2(M);    % Number of bits per symbol
n = 3e4;        % Number of bits to process
nsamp = 2;      % Oversampling rate

%% Signal Source
% Create a binary data stream as a column vector.
x = randi([0 1], n, 1); % Random binary data stream
% Bit-to-Symbol Mapping
y = bits_to_symbols(x, M);

%% Transmit Filter
% Define filter-related parameters.
filtorder = 40;               % Filter order
rolloff = 1;                  % Rolloff factor of filter
% tx filter and upsampling
ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);

%% plot eye diagram
h = eyediagram(ytx(1:2000),nsamp*2,2);
set(h, 'name', 'Before channel');

%% Channel
% Send signal over an AWGN channel.
EbNo = 10; % in dB
snr = EbNo + 10*log10(k) - 10*log10(nsamp);

ynoisy = awgn(ytx,snr,'measured');
 %= ytx;
%% plot eye diagram
h = eyediagram(ynoisy(1:2000),nsamp*2,2);
set(h, 'name', 'After channel');


%% Receive Filter
% rx filter and downsampling
yrx = DM_rx_filter(filtorder, rolloff, nsamp, ynoisy);

%% Scatter Plot
% Create scatter plot of received signal before and
% after filtering.
h = scatterplot(sqrt(nsamp)*ynoisy(1:nsamp*5e3),nsamp,0,'g.');
hold on;
scatterplot(yrx(1:5e3),1,0,'kx',h);
title('Received Signal, Before and After Filtering');
legend('Before Filtering','After Filtering');
axis([-5 5 -5 5]); % Set axis ranges.

%% Demodulation
% Demodulate signal using 16-QAM.
z = symbols_to_bits(yrx, M)';

%% BER Computation
% Compare x and z to obtain the number of errors and
% the bit error rate.
[number_of_errors, bit_error_rate] = biterr(x, z);

