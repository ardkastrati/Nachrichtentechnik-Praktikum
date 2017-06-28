function symbols = ofdm_rx( fft_len, n_carriers, cp_len, signal, eq_vector)

if n_carriers >= fft_len
    error('n_carriers must be smaller than fft_len')
end

if ~iscolumn(eq_vector) || length(eq_vector)~=fft_len
    error('Invalid eq_vector)')
end

ratio = length(signal)/(fft_len+cp_len);
n_osymb = floor(ratio);

if mod(ratio,1)~=0
    % n_carriers is not an integer divider of length(symbols)
    signal = signal(1:n_osymb*(fft_len+cp_len));
end

% seriell to parallel
signal = reshape(signal,(fft_len+cp_len),n_osymb);

% do fft
symbols = fft(signal,fft_len,1);

% do time shift (due to cp) -> shift theorem
symbols = symbols.*exp(2j*pi*(0:fft_len-1)'*cp_len/fft_len);

% equalization
symbols = symbols .* repmat(eq_vector,1,n_osymb);

% do fftshift
symbols = fftshift(symbols,1);

% extract carriers
n_zero = (fft_len-n_carriers-1)/2;
carriers = ...
    [zeros(ceil(n_zero),1); ...
    (floor(n_carriers/2)+1:n_carriers)';...
    0;...
    (1:floor(n_carriers/2))';...
    zeros(floor(n_zero),1)];
carriers = fftshift(find(carriers));
symbols = symbols(carriers,:);

% parallel to seriell
symbols = symbols(:);

end

