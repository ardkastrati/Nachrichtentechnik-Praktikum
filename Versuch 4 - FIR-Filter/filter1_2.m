% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 1.2: FIR-Filterentwurf mit Fourierapproximation - Einführung
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Parameter

% Filter ------------------------------------
Wn = 0.4;       % normalisierte Grenzfrequenz (1 entspricht Nyquistfrequenz)
n = 21;         % Filterlaenge
filt_amp = 1;   % Filterverstaerkung

%% Berechnungen

% Berechnung der Filterkoefizienten durch Fourierapproximation
b = Wn * sinc(Wn*(-(n-1)/2:(n-1)/2));


% Normierungsfaktoren im Frequenzbereich bestimmen
[H W]  = freqz(b,1,4096);


% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstärkung
% erreicht wird
b = filt_amp * b/H(1);

% Berechnung des Frequenzgangs
[H W]  = freqz(b,1,4096);

% Berechnung des Phasengangs
phi = phasez(b,1,W);


%% Anzeige des Frequenzgangs (Betrag) und Phasengangs
[AX,H1,H2] = plotyy(W/pi, abs(H),W/pi,phi);
grid on

% Beschriftung
set(get(AX(1),'Ylabel'), ...
    'String','$|H(\exp(j \Omega))/H(1)|$', ...
    'Interpreter','Latex' ...
) 
set(get(AX(2),'Ylabel'), ...
    'String','Phase (radian)' ...
) 
xlabel('$\Omega / \pi$','Interpreter','Latex');

title('Aufgabe 1.2: Tiefpass Phasengang und Amplitudengang');
