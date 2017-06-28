function signal = ofdm_tx(fft_len, n_carriers, cp_len, symbols)

if n_carriers >= fft_len
    error('n_carriers must be smaller than fft_len')
end

ratio = length(symbols)/n_carriers;
n_osymb = ceil(ratio); % number of output symbols

if mod(ratio,1)~=0
    % n_carriers is not an integer divider of length(symbols)
    symbols(n_osymb*n_carriers) = 0;
end

% Serial to parallel
symbols = reshape(symbols,n_carriers,n_osymb);

% arrange subcarriers
ind_upper = floor(n_carriers/2);
upper = symbols(1:ind_upper,:);
lower = symbols(ind_upper+1:end,:);
n_zero = (fft_len-n_carriers-1)/2;
symbols = [zeros(ceil(n_zero),n_osymb); lower; zeros(1,n_osymb); upper; zeros(floor(n_zero),n_osymb)];

% do ifft
signal = ifft(fftshift(symbols,1),fft_len,1);

% guard interval
if cp_len>fft_len
    warning('invalid cp_len');
elseif cp_len>0
%     signal = [signal; signal(1:cp_len,:)];
    
    signal = [signal(end-cp_len+1:end,:); signal];
end

% parallel to serial
signal = signal(:);

end