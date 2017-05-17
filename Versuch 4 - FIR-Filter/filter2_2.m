% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 4 - FIR-Multiratenfilter
%
%
% 2.2: Eigenschaften der Fensterfunktion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
% close all;
clc;

%% Parameter

% Filter ------------------------------------
n = 32;         % Filterlänge
filt_amp = 1;   % Filterverstärkung

%% Berechnungen

% Fensterfunktionen
b_rect = ones(1,n);                % Rechteckfenster
b_han  = b_rect .* hanning(n)';    % Hann-Fenster
b_ham  = b_rect .* hamming(n)';    % Hamming-Fenster

% Normierungsfaktoren im Frequenzbereich bestimmen
[H_rect ~] = freqz(b_rect, 1, 4096);
[H_han ~]  = freqz(b_han , 1, 4096);
[H_ham W]  = freqz(b_ham , 1, 4096);


% Filterkoeffizienten so skalieren, dass die gewünschte Filterverstärkung
% erreicht wird
b_rect = filt_amp * b_rect / H_rect(1);
b_han  = filt_amp * b_han  / H_han(1);
b_ham  = filt_amp * b_ham  / H_ham(1);


%% Ausgabe
h  = fvtool(b_rect,1,b_han,1,b_ham,1);
legend(h,'Rechteck','Hann','Hamming');
