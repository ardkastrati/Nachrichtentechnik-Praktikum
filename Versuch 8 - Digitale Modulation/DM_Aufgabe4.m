% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 9 - Digitale Modulation
%
%   Aufgabe 4: Verhalten bei Phasenoffset
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

warning('off','comm:obsolete:rcosine');
warning('off','comm:obsolete:rcosflt');

%% Setup
% Define parameters.
M = 4;       % Size of signal constellation
k = log2(M); % Number of bits per symbol
n = 1e5;     % Number of bits to process
nsamp = 4;   % Oversampling rate
diff_encoding = false;

phimin = 0;
phistep = pi/20;
phimax = pi;
phivec=phimin:phistep:phimax;

BER = zeros(length(phivec),1);

for i = 1:length(phivec)
    phi = phivec(i);

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

    % Define filter-related parameters.
    filtorder = 40;                 % Filter order
    rolloff = 1;                    % Rolloff factor of filter

    % tx filter
    ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);

    %% Channel
    yph = ytx .* exp(1j * phi);

    %% Received Signal
    % Filter received signal using square root raised cosine filter.
    yrx = DM_rx_filter(filtorder, rolloff, nsamp, yph);

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
    [~, BER(i)] = biterr(x, z(:));
end

plot(phivec, BER)

