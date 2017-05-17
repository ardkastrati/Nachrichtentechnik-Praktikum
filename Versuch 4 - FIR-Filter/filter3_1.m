%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 3.1: FIR-Filterentwurf mit Cosinus-Transformation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;


%% Parameter

% Filter
Wn =  0.3*2*pi  %;2*pi/8;     % Breite des Durchlassbereichs (in Radiant);
Omega_T =3.6; %2*pi/4;; %pi; %   % Parameter zur Filtertransformation (Mittenfrequenz in Radiant)
n = 31;             % Filterlänge
filt_amp = 1;       % Filterverstärkung

assert(~isnan(Wn) && ~isnan(Omega_T), 'Bitte Parameter für Wn und Omega_T eintragen')

%% Berechnungen

% Berechnung der Filterkoeffizienten durch Fourierapproximation
b = Wn/2/pi * sinc(Wn/2/pi*(-(n-1)/2:(n-1)/2));

% Abtastwerte der Cosinusfunktion erzeugen
b_cos = cos(Omega_T*(0:1:n-1));

% Normierungsfaktoren im Frequenzbereich bestimmen
[H W]  = freqz(b,1,4096);

% Filterkoeffizienten so skalieren, dass die gewünschte Filterverstärkung
% erreicht wird
b = filt_amp * b/H(1);

% Filtertransformation
c = b_cos.*b;



%% Ausgabe
fvtool(c,1);
