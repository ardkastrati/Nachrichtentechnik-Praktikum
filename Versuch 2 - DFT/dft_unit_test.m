% Unit test fuer fft_fut

% select "functions under test"
fft_fut = @fft_CT;
ifft_fut = @ifft_CT;

fprintf('Teste Parameter M=2......................');
try 
    fft_fut([0 0], 2);
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste Parameter M=3......................');
try 
    fft_fut([0 0 0], 3);
    
    fprintf('[Fehlgeschlagen]\n');
catch err
    fprintf('[      OK      ]\n');
end

fprintf('Teste Parameter M=4 (Rekursion)..........');
try 
    fft_fut([0 0 0 0], 4);
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste Dimension von Ausgabe..............');
try 
    assert(all(size(fft_fut([0 0 0 0] , 4)) == [1 4]))
    assert(all(size(fft_fut([0 0 0 0]', 4)) == [4 1]))
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste 1 = fft_(1, 1).....................');
try 
    X = fft_fut(1, 1);
    assert(all(abs(X - 1) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end


fprintf('Teste 0 = fft(0, 0)......................');
try 
    X = fft_fut(0, 0);
    assert(all(abs(X - 0) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste FFT mit M=4........................');
try 
    M = 4;
    for k = 0:M-1
        x = exp(2j*pi * k * (0:M-1) / M);
        X = fft_fut(x, M);
        assert(all(abs(X - fft(x, M)) < 1e-10))
    end
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste FFT zuf�llig.......................');
try 
    M = 256;
    x = randn(1, M) + 1j * randn(1, M);
    X = fft_fut(x, M);
    assert(all(abs(X - fft(x, M)) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste Zero Padding.......................');
try 
    x_zp = ifft(fft_fut(1, 8));
    assert(all(abs(x_zp(2:end)) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste Abschneiden........................');
try 
    x = [1 1 1 1 1 1 1 1];
    x_cut = ifft(fft_fut(x, 4));
    assert(all(abs(x_cut - x(1:4)) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Teste inverse Transformation.............');
try 
    M = 256;
    x = randn(1, M) + 1j * randn(1, M);
    xx = ifft_fut(fft(x, M), M);
    assert(all(abs(xx - x) < 1e-10))
    
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Fehlgeschlagen]\n');
end

fprintf('Suche nach fft() und ifft()..............');
try
    for file = {'fft_CT.m', 'ifft_CT.m'}
        fid = fopen(file{:}, 'r');
        while(~feof(fid))
           if ~isempty(strfind(fgetl(fid), 'fft(')) || ...
              ~isempty(strfind(fgetl(fid), 'ifft('))
                fclose(fid);
                assert False            
           end
        end
        fclose(fid);
    end
    fprintf('[      OK      ]\n');
catch err
    fprintf('[Durchgefallen!]\n');
end
