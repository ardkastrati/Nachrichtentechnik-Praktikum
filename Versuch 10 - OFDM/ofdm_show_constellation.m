%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   2. OFDM-Uebertragung und Konstellationsdiagramm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear variables;

%% OFDM-Einstellungen
fft_len    = 64;
n_carriers = 48;
cp_len     = 8;
n_symbols  = 100; % OFDM-Symbole
% Modulationsverfahren (eins davon auswaehlen):
%M = 2; % BPSK
%M = 4; % QPSK
%M = 8; % 8-PSK
M = 16; % 16-QAM
%M = 64; % 64-QAM

%% Kanal/Rauschen
noise_power = -30; % dBW

%% Sendesignal erzeugen
bits = randi([0 1], 1, n_symbols * n_carriers * log2(M));
tx_symbols = bits_to_symbols(bits, M);
tx_signal = ofdm_tx(fft_len, n_carriers, cp_len, tx_symbols);

% Leistung normieren
tx_signal = ofdm_normalize_power(tx_signal, fft_len, cp_len);

% Spektrum plotten
ofdm_plot_spectrum(tx_signal, 'Sendesignal');

%% Signal mit Rauschen ueberlagern
rx_signal = awgn(tx_signal, -noise_power);

% Spektrum plotten
ofdm_plot_spectrum(rx_signal, 'Empfangssignal');

%% Sendesymbol demodulieren
rx_symbols = ofdm_rx(fft_len, n_carriers, cp_len, rx_signal, ones(fft_len, 1));

% Konstellationsdiagramm anzeigen
scatterplot(rx_symbols);

