% Unit test fuer symbol_to_bits und bits_to_symbol

fprintf('Teste Ueberpruefung der Eingabeparameter (bits_to_symbols.m, M)...........');
try
    bits_to_symbols(ones(1, 100), 3);
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Ueberpruefung der Eingabeparameter (bits_to_symbols.m, bits)........');
try
    bits_to_symbols([1 2 3], 16);
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Ueberpruefung der Eingabeparameter (bits_to_symbols.m, Vektorlaenge)');
try
    bits_to_symbols(ones(1, 8), 8);
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Sendeleistung (bits_to_symbols.m)...................................');
power1 = mean(abs(bits_to_symbols(randi([0 1], 100000,1), 16)).^2);
power2 = mean(abs(bits_to_symbols(randi([0 1],  9000,1), 8)).^2);
if abs(power1 - 1) < 0.01 && abs(power2 - 1) < 0.01
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste bits_to_symbols auf korrekte Laenge der Ausgabe (2 Symbole).........');
if length(bits_to_symbols(randi([0 1], 1, 3*2), 8)) == 2
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste ob Eingabe == Ausgabe...............................................');
bits_in = randi([0 1], 1000, 1);
symbols = bits_to_symbols(bits_in, 16);
bits_out = symbols_to_bits(symbols, 16);
if bits_in(:) == bits_out(:)
    fprintf('[      OK      ]\n');
else
    fprintf('[Fehlgeschlagen]\n');
end

