% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 2.3: Eigenschaften der Fensterfunktion - Kaiser-Fenster
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Parameter

% Filter ------------------------------------
n = 32;         % Filterlaenge
filt_amp = 1;   % Filterverstaerkung
beta = [3 5 8]; % Parameter beta des Kaiser-Fensters

%% Berechnungen

% Kaiserfenster
b1 = kaiser(n,beta(1));
b2 = kaiser(n,beta(2));
b3 = kaiser(n,beta(3));

% Normierungsfaktoren im Frequenzbereich bestimmen
[H1 ~]  = freqz(b1,1,4096);
[H2 ~]  = freqz(b2,1,4096);
[H3 W]  = freqz(b3,1,4096);


% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstärkung
% erreicht wird
b1 = filt_amp * b1/H1(1);
b2 = filt_amp * b2/H2(1);
b3 = filt_amp * b3/H3(1);



%% Anzeige
h = fvtool(b1,1,b2,1,b3,1);
legend(h,['\beta = ' num2str(beta(1))],['\beta = ' num2str(beta(2))], ['\beta = ' num2str(beta(3))]);
