% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
% 
% Aufgabe 1. Spektrum eines DSSS-Signals
%
% cdma1.m : Spektrum eines ungespreizten und eines gespreizten Signals
%                                                      
%            ---------                                          
%       d ->|Spreizung|-> s
%            ---------
% 
%       d  : Info-Signal
%       b  : Spreizcode
%       s  : gespreiztes Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym = 1000;

% Spreizfaktor
SF = 4;

% Parameter fuer die Berechnung der mittleren PSD
NumberOfSegments = 5; % must be a factor of Nsym*SF*SF

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PN-Folge fuer Spreizung mit einem LFSR erzeugen
b = lfsr([3 31],[1 3 7 15 17 25 31],SF*Nsym);

% randint ist viel schneller als lfsr
% b = randint(1,SF*Nsym,[1 2]);

% 1,2 -> -1,1
b = b + 1;
b = LookUpTable(b);

% Info-Signal erzeugen
d = randi(2,1,Nsym);
d = LookUpTable(d);

% Hold fuer Spreizung
d = repmat(d,SF,1);
d = reshape(d,1,[]);



% Spreizung
s = b.*d;



% mittleres Leistungsdichtespektrum
PSDd = psd(d,NumberOfSegments,SF);
PSDs = psd(s,NumberOfSegments,SF);

% PSD auf ein Symbol normieren
PSDd = PSDd / Nsym;
PSDs = PSDs / Nsym;

% Frequenz
Omega = linspace(-0.5,0.5,length(PSDd));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','CDMA Spektren')
subplot(2,1,1); plot(Omega,PSDs,'r',Omega,PSDd,'b');
title('Leistungsdichtespektrum, linear');
axis([-inf inf -inf 500]);
legend('gespreiztes Signal','Info-Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,1,2); plot(Omega,10*log10(PSDs/max(PSDd)),'r',Omega,10*log10(PSDd/max(PSDd)),'b');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-inf inf -50 0]);
legend('gespreiztes Signal','Info-Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte / dB'); grid on;
