function bits = symbols_to_bits(symbols, M)
% Demoduliert einen Symbolstrom in Bits.
% M kann einen der folgenden Werte annehmen:
% M = 2: BPSK
% M = 4: QPSK
% M = 8: 8-PSK
% M = 16: 16-QAM
% M = 64: 64-QAM
%
% Es wird davon ausgegangen, dass die Leistung von symbols == 1 ist.

symbols = symbols(:);
if all(M ~= [2 4 8 16 64])
    error('M muss in [2, 4, 8, 16, 64] liegen.');
end

if M == 2 || M == 8
    h = modem.pskdemod(M);
elseif M == 4
    h = modem.pskdemod(4, pi/4);
elseif M == 16 || M == 64
    h = modem.qamdemod(M);
end
h.OutputType = 'bit';
h.SymbolOrder = 'gray';
constellation_power = sum(abs(h.Constellation).^2) / length(h.Constellation);

bits = demodulate(h, symbols * sqrt(constellation_power));

