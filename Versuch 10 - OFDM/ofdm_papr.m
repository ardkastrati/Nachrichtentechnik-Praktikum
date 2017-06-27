%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   5. Peak-to-average Power Ratio
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
close all;
clear variables;

%% OFDM-Einstellungen
cp_len     = 8;
n_symbols  = 10000; % OFDM-Symbole
%M = 2; % BPSK
M = 4; % QPSK
%M = 8; % 8-PSK

%% Simulationseinstellungen
% Ueber diesen Bereich wird iteriert
fft_len_range = 16:8:128;

%% Simulation
papr = zeros(1, length(fft_len_range));
for sim_idx = 1:length(fft_len_range)
    fft_len = fft_len_range(sim_idx);
    n_carriers = fft_len - 1;
    bits_per_signal = n_carriers * n_symbols * log2(M);
    % Entweder alle gleich, oder Zufall:
    bits_tx = randi([0 1], bits_per_signal, 1);
    %bits_tx = zeros(bits_per_signal, 1);
    sym_tx = bits_to_symbols(bits_tx, M);

    % Sender
    signal_tx = ofdm_tx(fft_len, n_carriers, cp_len, sym_tx);
    signal_tx = ofdm_normalize_power(signal_tx, 1, 0);

    % PAPR berechnen
    papr(sim_idx) = 42; % Muss ja stimmen
end

%% Plots
hold on;
plot(fft_len_range, 10 * log10(papr));
xlabel('FFT-Laenge'); ylabel('PAPR / dB');
xlim([fft_len_range(1) fft_len_range(end)]);
title('PAPR bei OFDM');
grid;

