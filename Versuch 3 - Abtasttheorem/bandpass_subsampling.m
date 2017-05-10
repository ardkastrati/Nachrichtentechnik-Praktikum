% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   bandpass_subsampling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Abtastrate
f_a=44;

%simulierte Zeitdauer
T=300;%seconds

% Signalmodus
signal_mode=5;

% Frequenz der Si-, Sinus- und Cosinus-Funktion
f0=0.5;%Hz

% Einschaltzeitpunkt des Signals
T_ein=0;%seconds

% Ausschaltzeitpunkt des Signals
T_aus=300;%seconds

% Hoechste dargestellte Frequenz
fg=22;%Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Erzeugung des abgetasteten Signals
signal=source(signal_mode,f_a,T,f0,T_ein,T_aus);

% Spektrum des abgetasteten Signals
[f,freq]=spectrum(signal,f_a,fg,floor(f_a*T)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der Simulationsergebnisse im Frequenzbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Frequenzbereich');
plot(f{1},freq{1},'-b');
grid on;
xlabel('Frequenz in Hz');
ylabel('Amplitude');
axis([-fg fg 0 Inf]);
