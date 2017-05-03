%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 2 - DFT
%                                                      
%   7. Zero Padding
%                                                      
%       x               : Folge im Zeitbereich 
%       x_16, x_32      : Folge im Zeitbereich nach Zero Padding
%       X, X_16, X_32   : DFT der jeweiligen Folge
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Folge
x = sin(linspace(0, 2*pi-1/4*pi, 8) );



% Zero Padding
x_16 = x; x_16(16) = 0;
x_32 = x; x_32(32) = 0;

x_100 = x; x_100(100) = 0;

% Diskrete Fourier Transformationen
X = fft(x);
X_16 = fft(x_16);
X_32 = fft(x_32);
X_100 = fft(x_100);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Urspruengliche Folge
figure('Name','Folge ohne Zero Padding')
subplot(2,1,1); stem(x); title('x'); xlabel('k'); 
subplot(2,1,2); stem(0:7,abs(X)); title('| DFT ( x ) |'); xlabel('n'); 

% Mit Zero Padding auf doppelte Laenge
figure('Name','Folge mit Zero Padding auf doppelte Laenge')
subplot(2,1,1); stem(x_16); title('x\_16'); xlabel('k'); 
subplot(2,1,2); stem(0:15,abs(X_16)); title('| DFT ( x\_16 ) |'); xlabel('n'); 

% Mit Zero Padding auf vierfache Laenge
figure('Name','Folge mit Zero Padding auf vierfache Laenge')
subplot(2,1,1); stem(x_32); title('x\_32'); xlabel('k'); 
subplot(2,1,2); stem(0:31,abs(X_32)); title('| DFT ( x\_32 ) |'); xlabel('n'); 

% Mit Zero Padding auf 11 Laenge
figure('Name','Folge mit Zero Padding auf Laenge 13')
subplot(2,1,1); stem(x_100); title('x\_100'); xlabel('k'); 
subplot(2,1,2); stem(0:99,abs(X_100)); title('| DFT ( x\_100 ) |'); xlabel('n'); 
