% Unit test fuer ofdm_tx und ofdm_rx

fprintf('Teste Ueberpruefung der Eingabeparameter (ofdm_tx.m).....................');
try
    ofdm_tx(8, 10, 0, []);
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Ueberpruefung der Eingabeparameter (ofdm_rx.m - FFT-Laenge)........');
try
    ofdm_rx(8, 10, 0, [], ones(8, 1));
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Ueberpruefung der Eingabeparameter (ofdm_rx.m - Entzerrersymbol)...');
try
    ofdm_rx(8, 4, 0, [], ones(7, 1));
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste ofdm_tx auf korrekte Laenge der Ausgabe (2 Symbole)................');
if length(ofdm_tx(16, 9, 4, zeros(1, 2*9))) == 2*20
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_tx auf korrekte Laenge der Ausgabe (3 Symbole)................');
if length(ofdm_tx(16, 9, 4, zeros(1, 2*9+6))) == 3*20
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_rx auf korrekte Laenge der Ausgabe (2 Symbole)................');
if length(ofdm_rx(16, 9, 4, zeros(1, 2*20), ones(16, 1))) == 2*9
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_rx auf korrekte Laenge der Ausgabe (mit Ueberschuss)..........');
if length(ofdm_rx(16, 9, 4, zeros(1, 2*20+4), ones(16, 1))) == 2*9
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_tx mit Testdaten..............................................');
if all(fftshift(fft(ofdm_tx(8, 5, 0, [1 -2 3 4j 5]))) - [0 3 4j 5 0 1 -2 0]' < 1e-6)
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_tx mit CP.....................................................');
if all(ofdm_tx(4, 3, 1, [-2-4j 8 -2+4j]) - [-4 1 0 3 -4]' < 1e-6)
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ofdm_tx in == ofdm_rx out..........................................');
tx_symbols = randi([0 1], 52*100, 1) * 2 - 1;
signal = ofdm_tx(64, 52, 8, tx_symbols);
rx_symbols = ofdm_rx(64, 52, 8, signal, ones(64, 1));
if sum(tx_symbols - rx_symbols) < 1e-6
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste Entzerrung.........................................................');
tx_symbols = [5 -2 6 4j]';
channel = (1:8)';
eq_vector = 1./channel;
signal = ofdm_tx(8, 4, 0, tx_symbols);

signal = ifft(fft(signal) .* channel);

rx_symbols = ofdm_rx(8, 4, 0, signal, eq_vector);
if all(abs(tx_symbols - rx_symbols) < 1e-6)
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

