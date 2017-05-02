%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 2 - DFT
%                                                      
%   9. Geschwindigkeitvergleich
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dft_speed()
    clear all
    close all
    clc
    
    % Compile C function
    mex('fft_CTc.c')
    fprintf('\n')
    
    %% Params

    % Length of the FFT to use
    M = 2^12;
    % Number of runs to average the timing result
    N = 5;
    % Labels and functions for the timing tests
    profiles = [
        struct('name', 'Matlab''s FFT', ...
               'func', @fft)
        struct('name', 'Cooley-Tukey FFT', ...
               'func', @fft_CT)
        struct('name', 'Cooley-Tukey FFT in C', ...
               'func', @fft_CTc)
        struct('name', 'a matrix DFT', ...
               'func', @dft_matrix)
        struct('name', 'a simple DFT', ...
               'func', @dft_simple)
    ];


    %% Simulation

    % create random data (used for all runs)
    x = randn(1, M) + 1j * randn(1, M);

    % run timing test for each profile
    for p = profiles'
        fprintf('Timing %s...', p.name)

        tic % start timer
        for i = 1:N            
            p.func(x, M); % run function N times
        end
        t = toc / N; % stop timer
        
        fprintf('Done.\n --> %gms\n\n', 1000*t)
    end
end    
    
function X = dft_matrix(x, M)
    X = x * exp(-2j*pi * kron(0:M-1, (0:M-1)') / M); 
end
    
function X = dft_simple(x, M)
    X = zeros(size(x));         
    for k = 1:M
        for n = 1:M
            X(k) = X(k) + x(n) * exp(-2j*pi*(n-1)*(k-1)/M);
        end
    end
end
    