function [ symbols ] = bits_to_symbols(bits, M)

if( M ~= 2 && M ~= 4 &&  M ~= 8 &&  M ~= 16)
    error('M must be a power of 2 and smaller or equal than 16')
end

if(mod(length(bits),log2(M)) ~= 0)
    error('Length of bits must be a multiple of log2(M)')
end

if (~all(bits==0 | bits==1))
    error('bits must contain only zeros and ones')
end
    
hBitToInt = comm.BitToInteger(log2(M));
tx_sym = step(hBitToInt, bits');

if(M==16)
    symbols = qammod(tx_sym, M, 'gray', 'UnitAveragePower', true)';
else 
    symbols = pskmod(tx_sym, M, 0,'gray')';
end

end

