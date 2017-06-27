k = 4;
M = 2^k;

bitsr = randi([0 1], 1, 1000000*k);
bitsc = randi([0 1], 1, 1000000*k);

bits = bitsr + 1j*bitsc;

symbols = bits_to_symbols(bits, M);
bits2 = symbols_to_bits(symbols, M);

isequal(bits, bits2)