function [ bits ] = symbols_to_bits( symbols, M)

if( M ~= 2 && M ~= 4 &&  M ~= 8 &&  M ~= 16)
    error('M must be a power of 2 and smaller or equal than 16')
end

if isrow(symbols) % transpose if neccessary
    symbols = symbols';
end

if(M == 16) 
    rx_sym = qamdemod(symbols, M, 'gray', 'UnitAveragePower', true);
else
    rx_sym = pskdemod(symbols, M, 0, 'gray');
    
end    

hIntToBit = comm.IntegerToBit(log2(M));
bits = step(hIntToBit,rx_sym)';

end

