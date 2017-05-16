%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 4.3: Multiratenfilter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Parameter

Fs = 1; % Abtastrate des Eingangssignals

% Anti-Aliasing Filter ------------------------------------
N_aa = 11;       % Filterlaenge
A_aa = 1;        % Filterverstaerkung
beta_aa = 5;     % Parameter beta des Kaiser-Fensters
Wn_aa = 0.1;     % Grenzfrequenz (in Vielfachen von fa/2)

% Dezimator -----------------------------------------------
M = 2;           % Dezimationsfaktor

% Kernfilter ----------------------------------------------
N_k = 11;        % Filterlänge
A_k = 1;         % Filterverstärkung
beta_k = 5;      % Parameter beta des Kaiser-Fensters
Wn_k = 0.5;      % Grenzfrequenz (in Vielfachen von fa/2)

% Interpolation--------------------------------------------
L = 2;           % Interpolationsfaktor

% Interpolations-Filter -----------------------------------
N_i = 11;        % Filterlaenge
A_i = 2;         % Filterverstaerkung
beta_i = 5;      % Parameter beta des Kaiser-Fensters
Wn_i = 0.5;      % Grenzfrequenz (in Vielfachen von fa/2)



%% Simulation

% Impulsantwort des Anti-Aliasing Filters berechnen und fenstern
h_aa = Wn_aa*sinc(Wn_aa*(-(N_aa-1)/2:(N_aa-1)/2)); % F{sinc(Ft)} = rect_{F/2}(f)
h_aa = h_aa.*kaiser(N_aa,beta_aa)';

% Normierungsfaktoren im Frequenzbereich bestimmen
[H_aa W_aa]  = freqz(h_aa,1,4096);
% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstaerkung
% erreicht wird
h_aa = A_aa * h_aa/H_aa(1);




% Impulsantwort des Kern-Filters berechnen und fenstern
h_k = Wn_k*sinc(Wn_k*(-(N_k-1)/2:(N_k-1)/2));
h_k = h_k.*kaiser(N_k,beta_k)';

% Normierungsfaktoren im Frequenzbereich bestimmen
[H_k W_k]  = freqz(h_k,1,4096);
% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstaerkung
% erreicht wird
h_k = A_k * h_k/H_k(1);




% Impulsantwort des Interpolations-Filters berechnen und fenstern
h_i = Wn_i*sinc(Wn_i*(-(N_i-1)/2:(N_i-1)/2));
h_i = h_i.*kaiser(N_i,beta_i)';

% Normierungsfaktoren im Frequenzbereich bestimmen
[H_i W_i]  = freqz(h_i,1,4096);
% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstaerkung
% erreicht wird
h_i = A_i * h_i/H_i(1);


% Heruntertasten
x3 = downsample(h_aa,M);

% Kernfilterung
x4 = conv(x3,h_k);

% Hochtasten
x5 = upsample(x4,L);

% Interpolationsfilter
x6 = conv(x5,h_i);


%% Anzeige
h = fvtool(h_aa,1,x3,1,x4,1,x5,1,x6,1);
set(h, 'MagnitudeDisplay', 'Magnitude (dB)');
set(h,'Fs',[Fs Fs/M Fs/M Fs/M*L Fs/M*L]);
set(h,'FrequencyRange','[-Fs/2, Fs/2)');

hchildren = get(h,'Children');

haxes = hchildren(strcmpi(get(hchildren,'type'),'axes'));
set(haxes,'YLim',[-70 10])
hline = get(haxes,'Children');
set(hline,'linewidth',1.5);
set(hline(1),'LineStyle','-');
set(hline(2),'LineStyle','--');
set(hline(3),'LineStyle',':');
set(hline(4),'LineStyle',':');
set(hline(5),'LineStyle','-.');
legend(h,'S2 - nach Anti-Aliasing','S3 - nach Dezimation','S4 - nach Kernfilter','S5 - nach Herauftastung','S6 - nach Anti-Image');
title('Monoratendarstellung')
