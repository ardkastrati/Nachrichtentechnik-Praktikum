%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   4. OFDM-Uebertragung und Konstellationsdiagramm bei
%      perfekter Synchronisation und Mehrwegekanal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

%% OFDM-Einstellungen
fft_len    = 64;
n_carriers = 48;
cp_len     = 8;
n_symbols  = 100; % OFDM-Symbole
% Modulationsverfahren (eins davon auswaehlen):
%M = 2; % BPSK
M = 4; % QPSK
%M = 8; % 8-PSK
%M = 16; % 16-QAM
%M = 64; % 64-QAM

% Symbole differenziell vorcodieren
% (in Zeitrichtung, auf jedem Untertraeger separat)
diff_encoding = true;

%% Mehrwegekanal
multi_path = [0.9+0.2j   0   0   -0.4+0.4j   0   0.3-0.15j].';
% Entzerrersymbol... was schreibt man hier sinnvollerweise rein?
eq_vector  = ones(fft_len, 1);

%% Simulationseinstellungen
snr_range = 15:1:35;
show_spectrum = true;
show_ber = false;
show_constellation = true;

%% Simulation
if ~show_ber && show_constellation
    % Geht schneller :)
    snr_range = snr_range(end);
end

ber = zeros(1, length(snr_range));
for snr_index = 1:length(snr_range)
    % Sendesignal erzeugen
    bits = randi([0 1], n_symbols * n_carriers * log2(M), 1);
    tx_symbols = bits_to_symbols(bits, M);
    if diff_encoding
        if M == 4
            tx_symbols = tx_symbols * exp(1j * pi/4);
        end
        tx_symbols = reshape(tx_symbols, n_carriers, n_symbols);
        tx_symbols(:, 1) = 1;
        tx_symbols_nondiff = tx_symbols;
        for i = 2:n_symbols
            tx_symbols(:, i) = tx_symbols_nondiff(:, i) .* tx_symbols(:, i-1);
        end
        clear tx_symbols_nondiff;
        tx_symbols = tx_symbols(:);
        bits = bits(n_carriers+1:end);
    end
    tx_signal = ofdm_tx(fft_len, n_carriers, cp_len, tx_symbols);

    %% Signal verzerren:
    % Mehrwegekanal
    rx_signal = filter(multi_path, 1, tx_signal);

    % Rauschen (mit 'measured' ist die SNR-Normierung nicht mehr notwendig)
    rx_signal = awgn(rx_signal, snr_range(snr_index), 'measured');

    %% Sendesymbol demodulieren
    rx_symbols = ofdm_rx(fft_len, n_carriers, cp_len, rx_signal, eq_vector);
    if diff_encoding
        rx_symbols = reshape(rx_symbols, n_carriers, n_symbols);
        rx_symbols_nondiff = rx_symbols;
        for i = 2:n_symbols
            rx_symbols_nondiff(:, i) = rx_symbols(:, i) ./ rx_symbols(:, i-1);
        end
        rx_symbols = rx_symbols_nondiff(:);
        if M == 4
            rx_symbols = rx_symbols * exp(-1j * pi/4);
        end
        clear rx_symbols_nondiff;
    end
    rx_bits = symbols_to_bits(rx_symbols, M);
    if diff_encoding
        rx_bits = rx_bits(n_carriers+1:end);
    end
    [~, ber(snr_index)] = biterr(bits, rx_bits);
end

% Spektrum plotten
if show_spectrum
    ofdm_plot_spectrum(rx_signal, 'Empfangssignal');
    grid on;
end

% Konstellationsdiagramm anzeigen
if show_constellation
    scatterplot(rx_symbols);
    axis([-1, 1,-1, 1] * 1.5)
    title('Konstellationsdiagramm auf allen Traegern');
end

% BER anzeigen
if show_ber
    figure;
    semilogy(snr_range, ber);
    xlabel('SNR / dB'); ylabel('BER');
    xlim([snr_range(1) snr_range(end)]);
    title('Bitfehlerrrate bei OFDM');
    grid;
end

