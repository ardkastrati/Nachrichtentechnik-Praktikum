% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 5. Rake-Empfaenger
%
% cdma6.m : RAKE-Empfaenger, 1 Nutzer, kein Rauschen
%                                  
%                                  
%            ---------         -----         ----
%       d ->|Spreizung|-> s ->|Kanal|-> r ->|RAKE|-> d_dach
%            ---------         -----         ----
%
%
%       d           : Info Signal
%       s           : gespreiztes Signal
%       r           : Signal nach Mehrwegeausbreitung
%       D_Rake      : Signal im Rake-Empfaenger, Martix mit Zeilen => Rake-Finger
%       d_dach      : Rake-Ausgang, Zeilenvektor 
%
%       C           : LFSR-Folge  
%       G           : Gold-Folge, Spreizcode    
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym      = 50;

% Spreizfaktor
SF           = 8;

% Generatorpolynome der Schieberegister
GenPoly1 = [7 18];
GenPoly2 = [5 7 10 18];

% Anfangsbelegung der Schieberegister
InitialState1 =  [1 3 7 10 15 18];

% 1 -> -1;  2 -> 1
LookUpTable = [-1 1];

% Kanal
B = [1 0.9 0.5 0.1];
A = 1;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Anzahl der Mehrwege
NumberOfPaths = length(B);

% Info-Signal erzeugen
d = randint(1,Nsym,[1 2]);
d = LookUpTable(d);



%%% Spreizung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Spreizcode: Gold-Code 
% Ca = lfsr(GenPoly1, InitialState1,Nsym*SF);
% Cb = lfsr(GenPoly2, InitialState1,Nsym*SF);
Ca = randint(1,SF*Nsym,[0 1]);
Cb = randint(1,SF*Nsym,[0 1]);
G = gfadd(Ca,Cb);

% 0,1 -> 1,2
G = G + 1;

% 1,2 -> -1,1
G = LookUpTable(G);

% Hold fuer Spreizung
d_hold = repmat(d,SF,1);
d_hold = reshape(d_hold,1,[]);

% Spreizung
s = G.*d_hold;

% gespreiztes Signal auf Energie 1 pro Symbol normieren
s = s./sqrt(SF);



%%% Mehrwegeausbreitung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Kanalimpulsantwort auf Energie 1 normieren
B = B ./ sqrt(sum(B.^2));

% FIR Filter
r = filter(B,A,s);



%%% RAKE Empfaenger %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rake Matrix -> Zeilen entsprechen Fingern, direkter Pfad -> letzte Zeile
D_Rake = [r(NumberOfPaths:end),zeros(1,NumberOfPaths-1)];
for k = 1 : NumberOfPaths-1
D_Rake = [ D_Rake;...
           r(NumberOfPaths-k:end),zeros(1,NumberOfPaths-k-1) ];
end

% Entspreizung in jedem Finger
for k = 1 : NumberOfPaths
    D_Rake(k,:) = G .* D_Rake(k,:);
end

% Chips aufsummieren
D_Rake = reshape(D_Rake,NumberOfPaths,SF,Nsym);
D_Rake = sum(D_Rake,2);
D_Rake = reshape(D_Rake,NumberOfPaths,Nsym);

% Taps aufsummieren mit Maximum Ration Combining (MRC)
D_Rake = D_Rake .* repmat(fliplr(B)',1,Nsym); %mrc
d_dach = sum(D_Rake); % Zeilen (also Finger) miteinander addieren
% => d_dach = Zeilenvektor Rake-Ausgang als Detektionsgrundlage





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','CDMA, Rake-Empfaenger')

subplot(211);
stem(s,'b'); hold on; stem(r,'r');
title('CDMA Mehrwegeuebertragung mit RAKE-Empfaenger, nur 1 Nutzer, kein Rauschen');
legend('Chips vor Mehrwegeausbreitung','Chips nach Mehrwegeausbreitung',1);
xlabel('Chips'); ylabel('Amplitude'); grid on;

subplot(212);
stem(d_dach,'r'); hold on; stem(d,'b');
title('CDMA Mehrwegeuebertragung mit RAKE-Empfaenger, nur 1 Nutzer, kein Rauschen');
legend('Ausgang Rake-Empfaenger','Sendesymole',1);
xlabel('Symbole'); ylabel('Amplitude'); grid on;
