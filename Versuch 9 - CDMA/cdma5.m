% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 5. Stoerresistenz 
%
% cdma5.m : Stoerresistenz
%
%                        noise
%       ---------         |               ------------
%  z ->|Spreizung|-> s -> + -> s_noise ->|Entspreizung|-> d_noise
%       ---------                         ------------ 
%
%
%       d          : Info Signal
%       s          : gespreiztes Signal
%       s_noise    : gestoertes Spreizsignal
%       d_noise    : entspreiztes Signal
%       d_diff     : d - d_noise
%
%       C          : LFSR-Folge  
%       G          : Gold-Folge, Spreizcode    
%       noise      : Stoerer
%       PSD        : Leistungsdichtespektrum 
%       
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym      = 1000;

% Spreizfaktor
SF           = 16;

%%% EDIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hold Faktor fuer Stoerer, HoldNoise kleiner gleich SF !
% HoldNoise = 8; % schmalbandiger Stoerer
HoldNoise = 1; % breitbandiger Stoerer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Konstante fuer Stoerer
ConstNoise = 0.8;

% Generatorpolynome der Schieberegister
GenPoly1 = [7 18];
GenPoly2 = [5 7 10 18];

% Anfangsbelegung der Schieberegister
InitialState =  [1 3 7 10 15 18];

% Parameter fuer die Berechnung der mittleren PSD
NumberOfSegments = 5; % must be a factor of Nsym*SF*SF

% Hold Faktor fuer PSD
HoldPSD = 4;

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Info-Signal erzeugen
d = randi(2,1,Nsym);
d = LookUpTable(d);


% Spreizcode: Gold-Code 
Ca = lfsr(GenPoly1, InitialState,Nsym*SF);
Cb = lfsr(GenPoly2, InitialState,Nsym*SF);
% Ca = randint(1,SF*Nsym,[0 1]);
% Cb = randint(1,SF*Nsym,[0 1]);
G = gfadd(Ca,Cb);

% 0,1 -> 1,2
G = G + 1;

% 1,2 -> -1,1
G = LookUpTable(G);


% Hold fuer Spreizung
d = repmat(d,SF,1);
d = reshape(d,1,[]);

% Spreizung
s = G.*d;

% Stoer-Signal erzeugen
noise_n = randi(2,1,Nsym*SF/HoldNoise);
noise = LookUpTable(noise_n);
noise = noise*ConstNoise;

% Hold fuer Stoerung
noise = repmat(noise,HoldNoise,1);
noise = reshape(noise,1,[]);

% Gestoertes Spreizsignal
s_noise  = s + noise;

% Entspreizug
d_noise = G.*s_noise;

% Differenz: Orginalsignal - Entspreiztes Signal
d_diff = d - d_noise;

% Leistungsdichrespektren berechnen
PSDd = psd(d,NumberOfSegments,HoldPSD);
PSDs = psd(s,NumberOfSegments,HoldPSD);
PSDnoise = psd(noise,NumberOfSegments,HoldPSD);
PSDs_noise = psd(s_noise,NumberOfSegments,HoldPSD);
PSDd_noise = psd(d_noise,NumberOfSegments,HoldPSD);
PSDd_diff = psd(d_diff,NumberOfSegments,HoldPSD);

% PSD auf ein Symbol normieren
PSDd = PSDd / Nsym;
PSDs = PSDs / Nsym;
PSDnoise = PSDnoise / Nsym;
PSDs_noise = PSDs_noise / Nsym;
PSDd_noise = PSDd_noise / Nsym;
PSDd_diff = PSDd_diff / Nsym;

% Frequenz
Omega = linspace(-0.5,0.5,length(PSDd));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% linear
figure('Name','Stoerresistenz CDMA, PSD linear')

subplot(2,2,1);  plot(Omega,PSDd,'b');
title('Leistungsdichtespektrum, linear');
axis([-0.5 0.5 0 8000]); legend('Info-Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,2,2);
plot(Omega,PSDs,'b',Omega,PSDnoise,'r');
title('Leistungsdichtespektrum, linear');
axis([-0.5 0.5 0 8000]); legend('Gespreiztes Signal','Stoerer');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,2,3);
plot(Omega,PSDd_noise,'b');
title('Leistungsdichtespektrum, linear');
axis([-0.5 0.5 0 8000]); legend('Entspreiztes Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,2,4);
plot(Omega,PSDd_diff,'r');
title('Leistungsdichtespektrum, linear');
axis([-0.5 0.5 0 8000]); legend('|Info-Signal - Entspreiztes Signal|');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;


% logarithmisch / dB
figure('Name','Stoerresistenz CDMA, PSD logarithmisch')

subplot(2,2,1);
plot(Omega,10*log10(PSDd/max(PSDd)),'b');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-0.5 0.5 -50 0]); legend('Info-Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte / dB'); grid on;

subplot(2,2,2);
plot(Omega,10*log10(PSDs/max(PSDd)),'b',Omega,10*log10(PSDnoise/max(PSDd)),'r');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-0.5 0.5 -50 0]); legend('Gespreiztes Signal','Stoerer');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte'); grid on;

subplot(2,2,3);
plot(Omega,10*log10(PSDd_noise/max(PSDd)),'b');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-0.5 0.5 -50 0]); legend('Entspreiztes Signal');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte / dB'); grid on;

subplot(2,2,4);
plot(Omega,10*log10(PSDd_diff/max(PSDd)),'r');
title('Leistungsdichtespektrum, semilogarithmisch');
axis([-0.5 0.5 -50 0]); legend('|Info-Signal - Entspreiztes Signal|');
xlabel('\Omega / \Pi'); ylabel('Leistungsdichte / dB'); grid on;

