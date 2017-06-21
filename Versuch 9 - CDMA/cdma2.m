% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 1. Spektrum eines DSSS-Signals
% 
% cdma2.m : Spektrum eines zweimal gespreizten Signals
%                                                      
%            ---------         ---------                 
%       d ->|Spreizung|-> s ->|Spreizung|-> s2
%            ---------         ---------
% 
%       d       : Info-Signal
%       b       : Spreizcode
%       b2      : weiterer Spreizcode gleicher Chiprate
%       s       : gespreiztes Signal
%       s2      : zweimal gespreiztes Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
% close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym      = 1000;

% Spreizfaktor
SF           = 4;

% Parameter fuer die Berechnung der mittleren PSD
NumberOfSegments = 5; % must be a factor of Nsym*SF*SF

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PN-Folge fuer Spreizung mit LFSRs erzeugen
b = lfsr([3 31],[1 3 7 15 17 25 31],SF*Nsym);
b2 = lfsr([3 31],[1 2 3 9 19 20 25 29 31],SF*Nsym);

% randint ist viel schneller als lfsr
% b = randint(1,SF*Nsym,[1 2]);
% b2 = randint(1,SF*Nsym,[1 2]);

% 1,2 -> -1,1
b = b + 1;
b2 = b2 + 1;
b = LookUpTable(b);
b2 = LookUpTable(b2);

% Info-Signal erzeugen
d = randi(2,1,Nsym);
d = LookUpTable(d);

% Wertewiederholung für Spreizung (Herauftastung und hold)
d = repmat(d,SF,1);
d = reshape(d,1,[]);



% Multiplikation mit Spreizcode
s = b.*d;

% Multiplikation mit weiterem Spreizcode
s2 = b2.*s;



% mittleres Leistungsdichtespektrum
PSDd = psd(d,NumberOfSegments,SF);
PSDs2 = psd(s2,NumberOfSegments,SF);

% PSD auf ein Symbol normieren
PSDd = PSDd / Nsym;
PSDs2 = PSDs2 / Nsym;

% Frequenz
Omega = linspace(-0.5,0.5,length(PSDd));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','CDMA Spektren')

subplot(2,1,1); plot(Omega,PSDs2,'b');
title('Leistungsdichtespektrum, linear');
axis([-inf inf -inf 500]); legend('doppelt gespreiztes Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,1,2);
plot(Omega,10*log10(PSDs2/max(PSDd)),'b');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-inf inf -50 0]); legend('doppelt gespreiztes Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte / dB'); grid on;
