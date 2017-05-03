function X = dft_matrix(x, M)
    X = x * exp(-2j*pi * kron(0:M-1, (0:M-1)') / M); 
end

