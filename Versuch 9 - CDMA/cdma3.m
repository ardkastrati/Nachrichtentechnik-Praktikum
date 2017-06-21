% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%                                                
% Aufgabe 3. Korrelationseigenschaften von Spreizcodes
%
% cdma3.m : Korrelationseigenschaften von Walsh-Folgen
%                                                      
%     
%       H -> w1,w2 -> KKF,AKF   
%
%       H   : Hadamard Matrix     
%       w1  : erste Walsh-Folge
%       w2  : zweite Walsh-Folge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Laenge der Walsh-Folgen
WalshLength = 128;

%%% EDIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auswahl der Walsh Folgen
column1 = 122;
column2 = 124;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Hadamard Matrix
H = hadamard(WalshLength);

% Walsh-Folgen
w1 = H(:,column1);
w2 = H(:,column2);

% Korrelationsfunktion
KF = xcorr(w1,w2,'coef');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Korrelation Walsh-Folgen')
stem(-127:127,abs(KF));
axis([-127 127 0 1]); grid on;
xlabel('\tau');
title('Betrag der Korrelationsfunktion der beiden Walsh-Folgen');
