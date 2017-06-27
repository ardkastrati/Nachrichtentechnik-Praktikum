
% n_symb = 100;
% symbols = complex(randn(n_symb,1), randn(n_symb,1));
% signal = ofdm_tx(64, 48, 48/8, symbols )
% 
% 
% %%
% signal = ofdm_tx(8, 4, 0, 1:4);
% stem(-4:3, fftshift(fft(signal)));
% length(ofdm_tx(16, 9, 4, 1:9))

%%
n_symb = 400;
% tx_symbols = complex(randn(n_symb,1), randn(n_symb,1));
tx_symbols = randi([0 1], n_symb, 1) * 2 - 1;
signal = ofdm_tx(8,4,2,tx_symbols);
rx_symbols = ofdm_rx(8,4,2, signal, ones(8,1));
all(abs(tx_symbols-rx_symbols)<.00000001)