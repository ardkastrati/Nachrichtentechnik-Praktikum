%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 11 - OFDM 
%
%   5. Clipping / PAPR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% close all;
clear variables;

%% OFDM-Einstellungen
fft_len    = 128;
n_carriers = 127;
cp_len     = 8;
n_symbols  = 100; % OFDM-Symbole
%M = 2; % BPSK
%M = 4; % QPSK
%M = 8; % 8-PSK
M = 16; % 16-QAM

threshold = 6; % dB

%% Simulationseinstellungen
% Ueber diesen Bereich wird iteriert
snr_range = -5:15;
show_ber = true;
show_spectrum = false;

bits_per_signal = n_carriers * n_symbols * log2(M);
eq_vector = ones(fft_len, 1);

%% Simulation starten
if ~show_ber
    % Kleine Abkuerzung
    snr_range = snr_range(end);
end
threshold_lin = 10^(threshold/20);
ber = zeros(1, length(snr_range)); % Speichert Bitfehlerrate
for sim_idx = 1:length(snr_range)
    snr = snr_range(sim_idx);

    % Sender
    bits_tx = randi([0 1], bits_per_signal, 1);
    sym_tx = bits_to_symbols(bits_tx, M);
    signal_tx = ofdm_tx(fft_len, n_carriers, cp_len, sym_tx);

    % Leistungsnormierung, diesmal auf 1
    signal_tx = ofdm_normalize_power(signal_tx, 1, 0);

    % Clipping (Phase muss natuerlich bleiben)
    signal_tx_clipped = signal_tx;
    signal_tx_clipped(abs(signal_tx) > threshold_lin) = ...
        signal_tx_clipped(abs(signal_tx) > threshold_lin) ...
        ./ abs(signal_tx_clipped(abs(signal_tx) > threshold_lin)) ...
        * threshold_lin;

    % Empfaengerrauschen
    signal_rx = awgn(signal_tx_clipped, snr);

    % Empfaenger
    sym_rx  = ofdm_rx(fft_len, n_carriers, cp_len, signal_rx, eq_vector);
    if M >= 8 
        sym_rx = sym_rx/std(sym_rx);
    end
    bits_rx = symbols_to_bits(sym_rx, M);

    % Bitfehlerrate berechnen
    [~, ber(sim_idx)] = biterr(bits_tx, bits_rx);
end

%% Komisch, hier stimmt's :)
EbN0_range = snr_range - 10 * log10(n_carriers/fft_len * log2(M));

%% Plots
if show_ber
%     figure;
    semilogy(EbN0_range, ber);
    if M == 2 || M == 4 || M == 8
        ber_theoretical = berawgn(EbN0_range, 'psk', M, 'nondiff');
    elseif M == 16 || M == 64
        ber_theoretical = berawgn(EbN0_range, 'qam', M);
    end
    hold on;
    semilogy(EbN0_range, ber_theoretical, 'r');
    legend('Clipping', 'Theoretisch');
    xlabel('SNR / dB'); ylabel('BER');
    xlim([EbN0_range(1) EbN0_range(end)]);
    title('Bitfehlerrrate bei OFDM');
    grid on;
end

if show_spectrum
    [Pxx, ~] = pwelch(signal_tx, [], [], fft_len);
    [Pxx_clipped, ~] = pwelch(signal_tx_clipped, [], [], fft_len);
%     figure;
    plot(((0:fft_len-1)-fft_len/2)/fft_len * 2 * pi, fftshift(10 * log10(Pxx)));
    xlim([-pi pi]); xlabel('Normierte Frequenz \Omega');
    ylabel('Leistungsdichte');
    title('Spektrum vor und nach Clipping');
    hold on;
    plot(((0:fft_len-1)-fft_len/2)/fft_len * 2 * pi, fftshift(10 * log10(Pxx_clipped)), 'r');
    grid on;
    legend('Spektrum vor Clipping 2db','Spektrum nach Clipping 2','Spektrum vor Clipping 6db','Spektrum nach Clipping 6')
end


%% calc papr
papr_cl = max(abs(signal_tx_clipped))^2/mean(abs(signal_tx_clipped))^2;
papr = max(abs(signal_tx))^2/mean(abs(signal_tx))^2;

10*log10(papr_cl) %papr in db

10*log10(mean(abs(signal_tx))^2) %average in db

%% plot signal
% figure
% plot(abs(signal_tx))
% hold on
% plot(abs(signal_tx_clipped))
% hold off
% legend('signal','clipped')