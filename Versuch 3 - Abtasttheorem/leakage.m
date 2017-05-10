% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   leakage: Ein abgetastetes sinusf�rmiges Signal wird und im Zeit- und
%   Frequenzbereich untersucht
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Abtastrate
f_a=8/7;

%L�nge der Diskreten Fouriertransformation
N_0=16;

%simulierte Zeitdauer
T=(N_0-1)/f_a;%seconds

% Signalmodus
signal_mode=2;

% Frequenz der Si-, Sinus- und Cosinus-Funktion
f0=0.5;%Hz

% Einschaltzeitpunkt des Signals
T_ein=0;%seconds

% Ausschaltzeitpunkt des Signals
T_aus=1000;%seconds

% Anzahl der Werte in den Graphen
N=1000;

% Hoechste dargestellte Frequenz
fg=f_a/2;%Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Erzeugung des abgetasteten Signals
signal=source(signal_mode,f_a,T,f0,T_ein,T_aus);

%Erzeugung des "kontinuierlichen" Signals, dient nur der Darstellung
%im Zeitbereich!
f_ueber=1000*2*f0;
signal_cont=source(signal_mode,f_ueber,T,f0,T_ein,T_aus);

% Diskretes Spektrum des abgetasteten Signals
[f_disc,freq_disc]=spectrum(signal,f_a,fg,T*f_a+1);

% "Kontinuierliches" Spektrum des abgetasteten Signals
[f_cont,freq_cont]=spectrum(signal,f_a,fg,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der Simulationsergebnisse im Zeitbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Zeitbereich');

% Darstellen der Abtastwerte
t=0:1/f_a:T;
t_cont=0:1/f_ueber:T;
hold on;
stem(t,signal{1},'-or','MarkerSize',10);
plot(t_cont,signal_cont{1},'-b','MarkerSize',10);
hold off

grid on;
xlabel('Zeit in s');
ylabel('Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der Simulationsergebnisse im Frequenzbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Frequenzbereich');

%Darstellen der rekonstruierten Signale
hold on;
plot(f_cont{1},freq_cont{1},'-b', 'MarkerSize', 10)
stem(f_disc{1},freq_disc{1},'or','MarkerSize',10);
hold off

grid on;
xlabel('Frequenz in Hz');
ylabel('Amplitude');
axis([-fg fg -Inf Inf]);

%Darstellen der Legende
legend('Spektrum','abgetastetes Spektrum');
