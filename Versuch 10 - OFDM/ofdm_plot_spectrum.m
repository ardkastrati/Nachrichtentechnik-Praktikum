function ofdm_plot_spectrum(signal, win_title, fft_len)
% Hilfsfunktion fuer den OFDM-Versuch: Spektrum plotten
%
% signal: Signal
% win_title: Titel des Fensters
% fft_len: Frequenzaufloesung
%

if nargin == 2
    fft_len = 512;
end

[Pxx, ~] = pwelch(signal, [], [], fft_len);
figure;
plot(((0:fft_len-1)-fft_len/2)/fft_len * 2 * pi, fftshift(10 * log10(Pxx)));
xlim([-pi pi]); xlabel('Normierte Frequenz \Omega');
ylabel('Leistungsdichte');
title(win_title);
