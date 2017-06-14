k = 4;
M = 2^k;

bits = randi([0 1] , 1, 1000000*k);

symbols = bits_to_symbols(bits, M);
bits2 = symbols_to_bits(symbols, M);

isequal(bits, bits2)