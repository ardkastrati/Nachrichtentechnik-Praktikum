% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 3. Korrelationseigenschaften von Spreizcodes
%
% cdma4.m : Korrelationseigenschaften von Gold-Folgen
%                                                      
%
%              XOR  
%       Ca,Cb  ->  G1 
%                      => Korrelation
%       Cc,Cd  ->  G2
%              XOR  
%
%
%       C : LFSR-Folge  
%       G : Gold-Folge
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Laenge der Gold-Folgen
GoldLength = 1000;

% Generatorpolynome der Schieberegister
GenPoly1 = [7 18];
GenPoly2 = [5 7 10 18];

% Anfangsbelegung der Schieberegister
InitialState1 =  [1 3 7 10 15 18];
%%% EDIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%InitialState2 = InitialState1;
InitialState2 =  [7 18];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Gold-Code 1
Ca = lfsr(GenPoly1, InitialState1,GoldLength);
Cb = lfsr(GenPoly2, InitialState1,GoldLength);
G1 = gfadd(Ca,Cb);

% Gold-Code 2
Cc = lfsr(GenPoly1, InitialState2,GoldLength);
Cd = lfsr(GenPoly2, InitialState2,GoldLength);
G2 = gfadd(Cc,Cd);

% 0,1 -> 1,2
G1 = G1 + 1;
G2 = G2 + 1;

% 1,2 -> -1,1
G1 = LookUpTable(G1);
G2 = LookUpTable(G2);


% Korrelation
KF = xcorr(G1,G2,'coef');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','Korrelation Gold-Folgen')
plot(-999:999,abs(KF)); axis([-999 999 0 1]);
title('Betrag der Korrelationsfunktion der beiden Gold-Folgen'); grid on;
xlabel('\tau')
