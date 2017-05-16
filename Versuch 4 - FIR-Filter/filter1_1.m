% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 1.1: FIR-Filterentwurf mit Fourierapproximation - Einführung
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Parameter 
% 1. Filter ---------------------------------
Wn1 = 0.4;      % normalisierte Grenzfrequenz (1 entspricht Nyquistfrequenz)
n1 = 21;        % Filterlaenge
filt_amp1 = 1;  % Filterverstaerkung

% 2. Filter ---------------------------------
Wn2 = 0.4;      % normalisierte Grenzfrequenz (1 entspricht Nyquistfrequenz)
n2 = 41;        % Filterlaenge
filt_amp2 = 1;  % Filterverstaerkung

% 3. Filter ---------------------------------
Wn3 = 0.4;      % normalisierte Grenzfrequenz (1 entspricht Nyquistfrequenz)
n3 = 101;       % Filterlaenge
filt_amp3 = 1;  % Filterverstaerkung

%% Berechnungen 

% Berechnung der Filterkoeffizienten durch Fourierapproximation
b1 = Wn1*sinc(Wn1*(-(n1-1)/2:(n1-1)/2)); % sinc für Rechtecktiefpass
b2 = Wn2*sinc(Wn2*(-(n2-1)/2:(n2-1)/2));
b3 = Wn3*sinc(Wn3*(-(n3-1)/2:(n3-1)/2));

% Normierungsfaktoren im Frequenzbereich bestimmen
[H1 ~]  = freqz(b1,1,4096); % Frequenzgang
[H2 ~]  = freqz(b2,1,4096);
[H3 ~]  = freqz(b3,1,4096);

% Filterkoeffizienten so skalieren, dass die gewuenschte Filterverstaerkung
% erreicht wird
b1 = filt_amp1 * b1/H1(1);
b2 = filt_amp2 * b2/H2(1);
b3 = filt_amp3 * b3/H3(1);

% Berechnung des Frequenzgangs
[H1 W1]  = freqz(b1,1,4096);
[H2 W2]  = freqz(b2,1,4096);
[H3 W3]  = freqz(b3,1,4096);


%% Anzeige des Amplitudengangs
hold on;
plot(W1/pi,abs(H1),'r');
plot(W2/pi,abs(H2),'g');
plot(W3/pi,abs(H3));
grid on;
legend(['N = ' num2str(n1)], ['N = ' num2str(n2)], ['N = ' num2str(n3)]);
xlabel('$\Omega / \pi$','Interpreter','Latex');
ylabel('Amplitudengang');
axis([0 1 0 1.3]);
title(['Aufgabe 1.1: Tiefpass Amplitudengang']); 
