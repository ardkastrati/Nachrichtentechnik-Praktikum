% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 9 - Digitale Modulation
%
%   Aufgabe 5: Verhalten bei Frequenzoffset
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

warning('off','comm:obsolete:rcosine');
warning('off','comm:obsolete:rcosflt');

%% Setup
% Define parameters.
M = 4; % Size of signal constellation
k = log2(M); % Number of bits per symbol
n = 3e4; % Number of bits to process
nsamp = 4; % Oversampling rate
diff_encoding = false;

freq_offset = 0.000002; % frequency offset (f_offset / f_A)

%% Signal Source
% Create a binary data stream as a column vector.
x = randi([0 1], n, 1); % Random binary data stream

% Bit-to-Symbol Mapping
y = bits_to_symbols(x, M);
if diff_encoding
    if M == 4
        y = y * exp(1j * pi/4);
    end
    y(1) = 1;
    y_nondiff = y;
    for j = 2:length(y)
        y(j) = y_nondiff(j) .* y(j-1);
    end
    clear y_nondiff;
    y = y(:);
    x = x(k+1:end);
end

%% Transmit Filter
% Define filter-related parameters.
filtorder = 40;               % Filter order
rolloff = 1;                  % Rolloff factor of filter

% tx filter and upsampling
ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);

%% Channel
% Send signal over an AWGN channel.
%EbNo = 60; % In dB
%snr = EbNo + 10*log10(k) - 10*log10(nsamp);
ynoisy = ytx; %awgn(ytx,snr,'measured');
% frequency offset
ynoisy = ynoisy .* exp(1j * 2 * pi * nsamp * freq_offset * (0:length(ynoisy)-1)).';

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
if diff_encoding
    yrx_nondiff = yrx;
    for j = 2:length(yrx)
        yrx_nondiff(j) = yrx(j) ./ yrx(j-1);
    end
    yrx = yrx_nondiff(:);
    if M == 4
        yrx = yrx * exp(-1j * pi/4);
    end
    clear yrx_nondiff;
end
z = symbols_to_bits(yrx, M);
if diff_encoding
    z = z(k+1:end);
end

%% BER Computation
% Compare x and z to obtain the number of errors and
% the bit error rate. 
if (length(x)>length(z))
    [number_of_errors,bit_error_rate] = biterr(x(1:length(z)),z);
end
if (length(x)<=length(z))
    [number_of_errors,bit_error_rate] = biterr(x,z(1:length(x)));
end

