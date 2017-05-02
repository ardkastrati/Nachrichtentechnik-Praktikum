%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 2 - DFT
%                                                      
%   6. Symmetrieeigenschaften der DFT reeller Folgen
%                                                      
%       x           : rein reelle Folge im Zeitbereich
%       x_gerade    : gerader Anteil von x
%       x_ungerade  : ungerader Anteil von x
%       X           : DFT von x
%       Xg          : DFT von x_gerade
%       Xu          : DFT von x_ungerade
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zufaellige rein reelle Folge, gleichverteilt im Intervall [-1,1]
x = rand(1,8)* 2 - 1;
x_gerade = (x + x(mod(8:-1:1,8)+1))/2;
x_ungerade = (x - x(mod(8:-1:1,8)+1))/2;


% Fourier Transformationen
X = fft(x);
Xg = fft(x_gerade);
Xu = fft(x_ungerade);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Zufaellige rein reelle Folge')
subplot(3,1,1); stem(x); title('x'); xlabel('k');
subplot(3,1,2); stem(real(X)); title('\Re \{ DFT ( x ) \}'); xlabel('n');
subplot(3,1,3); stem(imag(X)); title('\Im \{ DFT ( x ) \}'); xlabel('n');
   
figure('Name','Gerader Anteil')
subplot(3,1,1); stem(x_gerade); title('x\_gerade'); xlabel('k');
subplot(3,1,2); stem(real(Xg)); title('\Re \{ DFT ( x\_gerade ) \}'); xlabel('n');
subplot(3,1,3); stem(imag(Xg)); title('\Im \{ DFT ( x\_gerade ) \}'); xlabel('n');

figure('Name','Ungerader Anteil')
subplot(3,1,1); stem(x_ungerade); title('x\_ungerade'); xlabel('k');
subplot(3,1,2); stem(real(Xu)); title('\Re \{ DFT ( x\_ungerade ) \}'); xlabel('n');
subplot(3,1,3); stem(imag(Xu)); title('\Im \{ DFT ( x\_ungerade ) \}'); xlabel('n');
