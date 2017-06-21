% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nachrichtentechnisches Praktikum - Versuch 10 - CDMA
%
% Aufgabe 5. Rake-Empfaenger
%
% cdma8.m : RAKE-Empfaenger, 1 bis 4 Nuter,
%           AWGN Rauschen, variable Anzahl Nutzer
%
%
%             ---------          ---                 ----
%       d1 ->|Spreizung|-> s1 ->|   |   -----       |AWGN|            ----
%             ---------         |   |  |     |       ----            |    |
%                .              |   |  |     |        |              |    |
%                .              | + |->|Kanal|-> r -> + -> d_noise ->|RAKE|-> d_dach
%                .              |   |  |     |                       |    |
%             ---------         |   |  |     |                       |    |
%       d4 ->|Spreizung|-> s4 ->|   |   -----                         ----
%             ---------          ---
%
%
%       d           : Info Signal
%       d_hold      : Info Signal mit erhoehter Abtastrate
%       s           : gespreizted Signal
%       r           : Signal nach Mehrwegeausbreitung
%       d_noise     : Empfangssignal (nach Mehrwegeausbreitung und Rauschen)
%       D_Rake      : Signal im Rake-Empfaenger, Martix mit Zeilen => Rake-Finger
%       d_dach      : Rake-Ausgang, Zeilenvektor
%
%       C           : LFSR-Folge
%       G           : Gold-Folge, Spreizcode
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
% close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Symbole
Nsym = 1e5;

% Spreizfaktor
SF = 8;

% Anzahl der Nutzer
N_users = 1;

% Generatorpolynome der Schieberegister
GenPoly1 = [7 18];
GenPoly2 = [5 7 10 18];

% Anfangsbelegung der Schieberegister
InitialState1 =  [1 3 7 10 15 18];
InitialState2 =  [1 4 5 7 16 18];
InitialState3 =  [1 7 12 10 15 18];
InitialState4 =  [1 13 7 10 15 18];

% 1 -> -1; 2 -> 1
LookUpTable = [-1 1];

% Kanal
B = [1 0.2 0.1 0.05];
A = [1];

% zu simulierende Eb/N0s
EbN0 = -12:3:12;

% Bit Error Rate
BER = [];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anzahl der Mehrwege
NumberOfPaths = length(B);

% Schleife ueber die zu simulierenden Eb/N0s
for currentEbN0 = EbN0

    % Anzahl der Mehrwege
    NumberOfPaths = length(B);

    
    % Schleife ueber alle Nutzer
    for i = 1 : N_users;

        % Info-Signale erzeugen, Symbole
        d{i} = randint(1,Nsym,[1 2]);
        
        % 1 -> -1;  2 -> 1, -> Energie 1 pro Symbol
        d{i} = LookUpTable(d{i});
        
        
        %%% Spreizung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Spreizcode: Gold-Codes

        % PN Folge ueber Schieberegister -> LANGSAM!
        %     Ca{i} = lfsr(GenPoly1, InitialState{i},Nsym*SF);
        %     Cb{i} = lfsr(GenPoly2, InitialState{i},Nsym*SF);
        
        % PN Folge ueber randint Funktion -> SCHNELL!
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
        
        % Nutzer ueberlagern
        if i == 1
            s_all = s{i};
        else
            s_all = s_all + s{i};
        end
        
    end

    
    %%% Mehrwegeausbreitung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Kanalimpulsantwort auf Energie 1 normieren
    B = B ./ sqrt(B*B');

    % FIR Filter
    r = filter(B,A,s_all);



    %%% AWGN Rauschen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % lineares Signal- zu Rauschverhaeltnis
    currentEbN0lin = 10 ^ (currentEbN0/10);
    % Rauschen erzeugen und normieren (auf EINEN Nutzer)
    noise = randn(1,SF*Nsym)/(sqrt(currentEbN0lin));
    % Signal und Rauschen addieren
    d_noise = r + noise;


    %%% RAKE Empfaenger %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Rake Matrix -> Zeilen entsprechen Fingern, direkter Pfad -> letzte Zeile
    D_Rake = [d_noise(NumberOfPaths:end),zeros(1,NumberOfPaths-1)];
    for k = 1 : NumberOfPaths-1
        D_Rake = [ D_Rake;...
            d_noise(NumberOfPaths-k:end),zeros(1,NumberOfPaths-k-1) ];
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

    % Detektion, BER
    tmp = find(d_dach<0);
    d_dach(tmp) = 0;
    errors = length(find( xor(d_dach,d{1}+1) ));

    % Bit Error Rate berechnen und speichern
    BER = [BER,errors/Nsym];
    display(sprintf('Eb/N0 = %3d dB \t BER = %d',currentEbN0,BER(end)));
end


% BER idealer AWGN-Kanal, antipodale Signale (-1,1)
% 1 Bit -> 1 Symbol -> 4 Chips => Eb/N0 entspricht SF * SNRlinear
% => Faktor SF entspricht 10*log10(SF) / dB
BER_awgn = berawgn(EbN0,'psk',2,'nondiff');


%EbN0_lin = 10.^(EbN0/10);
%BER_awgn = 0.5*erfc(sqrt(EbN0_lin));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'CDMA, Rake-Empfaenger')
semilogy(EbN0,BER,'b-',EbN0,BER_awgn,'k--');
title({['CDMA Mehrwegeuebertragung mit RAKE-Empfaenger'],...
    [sprintf('%d Nutzer, %d Taps',N_users, NumberOfPaths), ', AWGN Rauschen']});
legend('BER Nutzer A','BER AWGN',1); axis([-inf inf -inf 0.5]);
xlabel('E_b/N_0'); ylabel('BER'); grid on;

