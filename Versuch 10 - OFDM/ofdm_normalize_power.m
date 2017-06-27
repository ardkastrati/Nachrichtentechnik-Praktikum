function signal = ofdm_normalize_power(signal, fft_len, cp_len)
% Normiert die Leistung des OFDM-Signals 'signal' so, dass
% die Leistung = 1 ist, wenn das CP == 0. Wenn CP > 0 wird
% die Symbolenergie gleichmaessig auf OFDM-Symbol und CP aufgeteilt.

sig_power = mean(abs(signal).^2);
normalization_factor = (fft_len + cp_len) / fft_len;
signal = signal .* sqrt(normalization_factor / sig_power);
