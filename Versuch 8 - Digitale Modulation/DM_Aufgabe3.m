%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Digitale Modulation
%
%   Aufgabe 3: Bitfehlerwahrscheinlichkeit fuer PSK und DPSK
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear variables;
%close all;

%% Setup
% Define parameters.
M = 8;          % Size of signal constellation
diff_encoding = true#;   % Turn differential encoding on/off
k = log2(M);    % Number of bits per symbol
n = 24e5;       % Number of bits to process
% n = 8;

theoretical = 1;% Plotting of theoretical results
                % for theoretical = 1
EbNomin = 4;  % dB
EbNomax = 10; % dB
EbNostep = 2;
EbN0range = EbNomin:EbNostep:EbNomax;
BER = zeros(length(EbN0range), 1);
BERtheoretical = BER;

%% Simulation Loop
for i = 1:length(EbN0range)
    EbNo = EbN0range(i);
    tx_bits = randi([0 1], n, 1); % Random binary data stream

    % Bit-to-Symbol Mapping
    tx_symbols = bits_to_symbols(tx_bits, M);
    if diff_encoding
        if M == 4
            tx_symbols = tx_symbols * exp(1j * pi/4);
        end
        tx_symbols(1) = 1;
        tx_symbols_nondiff = tx_symbols;
        for j = 2:length(tx_symbols)
            tx_symbols(j) = tx_symbols_nondiff(j) .* tx_symbols(j-1);
        end
        clear tx_symbols_nondiff;
        tx_symbols = tx_symbols(:);
        tx_bits = tx_bits(k+1:end);
    end

    %% Channel
    snr = EbNo + 10*log10(k);
%     rx_symbols = tx_symbols;
    rx_symbols = awgn(tx_symbols, snr);

    %% Demodulation
    if diff_encoding
        rx_symbols_nondiff = rx_symbols;
        for j = 2:length(rx_symbols)
            rx_symbols_nondiff(j) = rx_symbols(j) ./ rx_symbols(j-1);
        end
        rx_symbols = rx_symbols_nondiff(:);
        if M == 4
            rx_symbols = rx_symbols * exp(-1j * pi/4);
        end
        clear rx_symbols_nondiff;
    end
    rx_bits = symbols_to_bits(rx_symbols, M);
    if diff_encoding
        rx_bits = rx_bits(k+1:end);
    end

    %% BER Computation
    % Compare x and z to obtain the number of errors and
    % the bit error rate.
    [~, BER(i)] = biterr(tx_bits, rx_bits);

    if diff_encoding
        BERtheoretical(i) = berawgn(EbNo, 'dpsk', M);
    else
        BERtheoretical(i) = berawgn(EbNo, 'psk', M, 'nondiff');
    end
end

%% Plot
semilogy(EbNomin:EbNostep:EbNomax,BER, 'b-');
hold on

if theoretical
    semilogy(EbNomin:EbNostep:EbNomax,BERtheoretical,'g--');
    %legend('Measured', 'Theoretical');
end
grid on