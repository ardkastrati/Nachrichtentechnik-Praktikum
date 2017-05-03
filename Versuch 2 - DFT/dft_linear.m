%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 2 - DFT
%                                                      
%   3. Linearität der DFT
% 
%       x_ges          : gesamte Folge
%       x1,x2,x3       : Teilfolgen
%       X_ges,X1,X2,X3 : entsprechende DFTs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Gesamte Folge
x_ges = rand(1,8);

% Vektoren initialisieren
x1 = zeros(1,8); x2 = zeros(1,8); x3 = zeros(1,8);

% Teilfolgen erstellen
x1(1:3:8) = x_ges(1:3:8);
x2(2:3:8) = x_ges(2:3:8);
x3(3:3:8) = x_ges(3:3:8);

% Diskrete Fourier Transformation
X_ges = fft(x_ges);
X1 = fft(x1);
X2 = fft(x2);
X3 = fft(x3);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Linearität der DFT')

% Gesamte Folge
subplot(5,3,1); stem(x_ges,'r'); title('x_{ges}'); xlabel('k'); axis([1 8 0 1]);
subplot(5,3,2); stem(real(X_ges),'r'); title('\Re \{ DFT ( x_{ges} ) \}'); xlabel('n');
subplot(5,3,3); stem(imag(X_ges),'r'); title('\Im \{ DFT ( x_{ges} ) \}'); xlabel('n');

% Folge 1
subplot(5,3,4); stem(x1); title('x_1'); xlabel('k'); axis([1 8 0 1]);
subplot(5,3,5); stem(real(X1)); title('\Re \{ DFT ( x_1 ) \}'); xlabel('n'); 
subplot(5,3,6); stem(imag(X1)); title('\Im \{ DFT ( x_1 ) \}'); xlabel('n'); 

% Folge 2
subplot(5,3,7); stem(x2); title('x_2'); xlabel('k'); axis([1 8 0 1]);
subplot(5,3,8); stem(real(X2)); title('\Re \{ DFT ( x_2 ) \}'); xlabel('n'); 
subplot(5,3,9); stem(imag(X2)); title('\Im \{ DFT ( x_3 ) \}'); xlabel('n');

% Folge 3
subplot(5,3,10); stem(x3); title('x_3'); xlabel('k'); axis([1 8 0 1]);
subplot(5,3,11); stem(real(X3)); title('\Re \{ DFT ( x_3 ) \}'); xlabel('n'); 
subplot(5,3,12); stem(imag(X3)); title('\Im \{ DFT ( x_3 ) \}'); xlabel('n');

% Summe Folge 1,2,3
subplot(5,3,13); stem(x1 + x2 + x3,'r'); title('x_1 + x_2 + x_3'); 
    xlabel('k'); axis([1 8 0 1]);
subplot(5,3,14); stem(real(X1) + real(X2) + real(X3),'r'); 
    title('\Re \{ DFT(x_1) + DFT(x_2) + DFT(x_3) \}'); xlabel('n'); 
subplot(5,3,15); stem(imag(X1) + imag(X2) + imag(X3),'r'); 
    title('\Im \{ DFT(x_1) + DFT(x_2) + DFT(x_3) \}'); xlabel('n'); 
    
    
