function symbols = bits_to_symbols(bits, M)
% Moduliert einen Bitstrom (1 oder 0) in digitale Modulationssymbole.
% M kann einen der folgenden Werte annehmen:
% M = 2: BPSK
% M = 4: QPSK
% M = 8: 8-PSK
% M = 16: 16-QAM
% M = 64: 64-QAM
%
% Das Ausgangssignal hat immer die Leistung 1.

bits = bits(:);
if ~all((bits == 1) + (bits == 0))
    error('Bits muessen entweder 1 or 0 sein.');
end
if mod(log2(M), 1) || all(M ~= [2 4 8 16 64])
    error('M muss in [2, 4, 8, 16, 64] liegen.');
end
if mod(length(bits), log2(M))
    error('Anzahl Bits muss ganzzahliges Vielfaches der Symbolwertigkeit sein.');
end
!
if M == 2 || M == 8
    h = modem.pskmod(M);
elseif M == 4
    h = modem.pskmod(4, pi/4);
elseif M == 16 || M == 64
    h = modem.qammod(M);
end
h.InputType = 'bit';
h.SymbolOrder = 'gray';
constellation_power = sum(abs(h.Constellation).^2) / length(h.Constellation);

symbols = modulate(h, bits) ./ sqrt(constellation_power);
