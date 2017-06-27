%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   3. OFDM-Uebertragung via AWGN-Kanal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
close all;
clear variables;

%% OFDM-Einstellungen
fft_len    = 64;
n_carriers = 48;
cp_len     = 8;
n_symbols  = 1000; % OFDM-Symbole
%M = 2; % BPSK
M = 4; % QPSK
%M = 8; % 8-PSK


%% Simulationseinstellungen
% Ueber diesen Bereich wird iteriert
snr_range = -10:10;
show_theoretical_ber = false;

bits_per_signal = n_carriers * n_symbols * log2(M);
eq_vector = ones(fft_len, 1);

%% Simulation starten
ber = zeros(1, length(snr_range)); % Speichert Bitfehlerrate
for sim_idx = 1:length(snr_range)
    snr = snr_range(sim_idx);

    % Sender
    bits_tx = randi([0 1], bits_per_signal, 1);
    sym_tx = bits_to_symbols(bits_tx, M);
    signal_tx = ofdm_tx(fft_len, n_carriers, cp_len, sym_tx);

    % Leistungsnormierung.
    % Hinweis: Diese Zeile ist korrekt.
    % Waere dies anders, koennte man die Kurven nicht untereinander vergleichen.
    signal_tx = ofdm_normalize_power(signal_tx, fft_len, cp_len);

    % Empfaengerrauschen
    % awgn() geht davon aus, dass die Sendeleistung auf 1 normiert ist.
    signal_rx = awgn(signal_tx, snr);

    % Empfaenger
    sym_rx  = ofdm_rx(fft_len, n_carriers, cp_len, signal_rx, eq_vector);
    bits_rx = symbols_to_bits(sym_rx, M);

    % Bitfehlerrate berechnen
    [~, ber(sim_idx)] = biterr(bits_tx, bits_rx);
end

%% Die folgende Zeile koennte falsch sein:
EbN0_range = snr_range;

%% Plots
figure;
semilogy(EbN0_range, ber);
if show_theoretical_ber
    if M == 2 || M == 4 || M == 8
        ber_theoretical = berawgn(EbN0_range, 'psk', M, 'nondiff');
    elseif M == 16 || M == 64
        ber_theoretical = berawgn(EbN0_range, 'qam', M);
    end

    hold on;
    semilogy(EbN0_range, ber_theoretical, 'r');
    legend('Simulation', 'Theoretisch');
end
xlabel('SNR / dB'); ylabel('BER');
xlim([EbN0_range(1) EbN0_range(end)]);
title('Bitfehlerrate bei OFDM');
grid;

