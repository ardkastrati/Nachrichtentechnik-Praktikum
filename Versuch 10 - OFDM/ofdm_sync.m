%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   4. OFDM-Uebertragung und Konstellationsdiagramm bei
%      fehlerhafter Synchronisation.
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
M = 2; % BPSK
%M = 4; % QPSK
%M = 8; % 8-PSK
%M = 16; % 16-QAM
%M = 64; % 64-QAM

%% Synchronisation/Rauschen
snr = 30; % dB
% Frequenzoffset
delta_f = 0.01; % Untertraegerabstand, nomiert auf Samplingrate: FALSCH!
% 4 interessante Optionen:
freq_offset = delta_f * 0;
%freq_offset = delta_f * 0.01;
%freq_offset = delta_f * 1;
%freq_offset = delta_f * 0.99;
% Zeitoffset
% Muss in dieser Simulation eine ganze Zahl bleiben!
% Offset > 0: Das Signal wird zu spaet erkannt.
time_offset = 0;
% Phasenoffset: In [0, 2*pi]
phase_offset = 0;

%% Sendesignal erzeugen
bits = randi([0 1], 1, n_symbols * n_carriers * log2(M));
tx_symbols = bits_to_symbols(bits, M);
tx_signal = ofdm_tx(fft_len, n_carriers, cp_len, tx_symbols);

%% Signal verzerren:
% Zeitoffset:
if time_offset > 0
    rx_signal = tx_signal(time_offset+1:end);
    rx_signal(length(tx_signal)) = 0;
else
    rx_signal = zeros(length(tx_signal), 1);
    rx_signal(-time_offset+1:end) = tx_signal(1:end+time_offset);
end

% Frequenzoffset:
rx_signal = rx_signal .* exp(1j * 2 * pi * freq_offset * (0:length(tx_signal)-1)');

% Absolutphasenoffset:
rx_signal = rx_signal .* exp(1j * phase_offset);

% Rauschen (mit 'measured' ist die SNR-Normierung nicht mehr notwendig,
% bzw. wird auf Signalleistung normiert)
rx_signal = awgn(rx_signal, snr, 'measured');

% Spektrum plotten
ofdm_plot_spectrum(rx_signal, 'Empfangssignal');
grid on;

%% Sendesymbol demodulieren
rx_symbols = ofdm_rx(fft_len, n_carriers, cp_len, rx_signal, ones(fft_len, 1));

% Konstellationsdiagramm anzeigen
scatterplot(rx_symbols(2:n_carriers:end));
title('Konstellationsdiagramm auf Traeger 2');
scatterplot(rx_symbols);
title('Konstellationsdiagramm auf allen Traegern');

