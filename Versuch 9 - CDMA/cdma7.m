% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 5. Rake-Empfaenger
%
% cdma7.m : RAKE-Empfaenger, 4 Nutzer, kein Rauschen, Nutzer 1 wird empfangen
%
%
%             ---------          ---
%       d1 ->|Spreizung|-> s1 ->|   |   -----         ----
%             ---------         |   |  |     |       |    |
%                .              |   |  |     |       |    |
%                .              | + |->|Kanal|-> r ->|RAKE|-> d_dach
%                .              |   |  |     |       |    |
%             ---------         |   |  |     |       |    |
%       d4 ->|Spreizung|-> s4 ->|   |   -----         ----
%             ---------          ---
%
%
%       d           : Info Signal
%       d_hold      : Info Signal mit erhoehter Abtastrate
%       s           : gespreizted Signal
%       r           : Signal nach Mehrwegeausbreitung
%       D_Rake      : Signal im Rake-Empfaenger, Martix mit Zeilen => Rake-Finger
%       d_dach      : Rake-Ausgang, Zeilenvektor
%
%       C           : LFSR-Folge
%       G           : Gold-Folge, Spreizcode
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym = 50;

% Spreizfaktor
SF = 8;

% Generatorpolynome der Schieberegister
GenPoly1 = [7 18];
GenPoly2 = [5 7 10 18];

% Anfangsbelegung der Schieberegister
InitialState{1} =  [1 3 7 10 15 18];
InitialState{2} =  [1 4 5 7 16 18];
InitialState{3} =  [1 7 12 10 15 18];
InitialState{4} =  [1 13 7 10 15 18];

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];

% Kanal
B = [1 0.9 0.5 0.1];
A = 1;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Mehrwege
NumberOfPaths = length(B);

% Schleife ueber alle Nutzer
for i = 1 : 4;
    
    % Info-Signale erzeugen
    d{i} = randint(1,Nsym,[1 2]);
    d{i} = LookUpTable(d{i});

    
    %%% Spreizung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Spreizcode: Gold-Codes

    % Ca{i} = lfsr(GenPoly1, InitialState{i},Nsym*SF);
    % Cb{i} = lfsr(GenPoly2, InitialState{i},Nsym*SF);
    Ca{i} = randint(1,SF*Nsym,[0 1]);
    Cb{i} = randint(1,SF*Nsym,[0 1]);
    G{i} = gfadd(Ca{i},Cb{i});

    % 0,1 -> 1,2
    G{i} = G{i} + 1;

    % 1,2 -> -1,1
    G{i} = LookUpTable(G{i});

    % Hold fuer Spreizung
    d_hold{i} = repmat(d{i},SF,1);
    d_hold{i} = reshape(d_hold{i},1,[]);

    % Spreizung
    s{i} = G{i}.*d_hold{i};


    % gespreizte Signale auf Energie 1 pro Symbol normieren
    s{i} = s{i}./sqrt(SF);

    % alle Nutzer ueberlagern
    if i == 1
        s_all = s{i};
    else
        s_all = s_all + s{i};
    end

end



%%% Mehrwegeausbreitung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Kanalimpulsantwort auf Energie 1 normieren
B = B ./ sqrt(sum(B.^2));

% FIR Filter
r = filter(B,A,s_all);



%%% RAKE Empfaenger %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rake Matrix -> Zeilen entsprechen Fingern, direkter Pfad -> letzte Zeile
NumberOfPaths = length(B);
D_Rake = [r(NumberOfPaths:end),zeros(1,NumberOfPaths-1)];
for k = 1 : NumberOfPaths-1
    D_Rake = [ D_Rake;...
        r(NumberOfPaths-k:end),zeros(1,NumberOfPaths-k-1) ];
end

% Entspreizung in jedem Finger
for k = 1 : NumberOfPaths
    D_Rake(k,:) = G{1} .* D_Rake(k,:);
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

subplot(211)
stem(s{1},'b'); hold on; stem(r,'r');
title('CDMA Mehrwegeuebertragung mit RAKE-Empfaenger, 4 Nutzer, kein Rauschen');
legend('Chips Nutzer 1','Signal vor Rake-Empfaenger (4 Nutzer + Mehrwegeausbreitung)',1);
xlabel('Chip'); ylabel('Amplitude'); grid on;

subplot(212);
stem(d_dach,'r'); hold on; stem(d{1},'b');
title('CDMA Mehrwegeuebertragung mit RAKE-Empfaenger, 4 Nutzer, kein Rauschen');
legend('Signal nach Rake-Empfaenger fuer Nutzer 1','Sendesymbole Nutzer 1',1);
xlabel('Symbol'); ylabel('Amplitude'); grid on;
