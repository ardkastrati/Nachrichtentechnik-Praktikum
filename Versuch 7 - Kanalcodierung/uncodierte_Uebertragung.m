%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   1. Ermittlung von Bitfehlerraten
%   Uncodierte Uebertragung                                                   
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Abbruch der Simulation nach

% - Anzahl der simulierten Bits
% - Anzahl = -1 --> Berechnung fuer feste Bitanzahl deaktiviert
Anzahl = [100,1000,100000];
%Anzahl = -1;

% - Anzahl der aufgetretenen Fehler
% - Fehlerzahl = -1 --> Berechnung fuer feste Fehlerzahl deaktiviert
Fehlerzahl = [10,100,1000];
%Fehlerzahl = -1;

%Signal-zu-Rausch-Verhaeltnis
SNR = [-5:1:6];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Variablen initialisieren
i=0;
k=0;

BER_Anz = zeros(length(Anzahl),length(SNR));
BER_Fehl = zeros(length(Fehlerzahl),length(SNR));

%Erzeuge Random Bits
sourceBitsInt = randi([0,1],1,1e6);

%NRZ-Codierung
sourceBits = sign(sourceBitsInt - 0.5);


%Simulationsschleife Feste Bitanzahl

Pb = qfunc(sqrt(10.^(SNR/10)));
if (Anzahl ~= -1)
    for i=1:length(Anzahl)  
        for j=1:length(SNR) 
            %Erzeuge Empfangsbits nach AWGN-Kanal
            resultBits = awgn(sourceBits(1:Anzahl(i)),SNR(j));

            %Vergleiche gestoerte Empfangsbits mit Sendebits
            errorBits = xor((0.5*sourceBits(1:Anzahl(i)))+0.5,0.5*sign(resultBits)+0.5);

            %Anzahl der Einsen im Verktor errorBits entspricht Anzahl der
            %Uebertragungsfehler
            sumErrors = sum(errorBits);

            %BER = (Anzahl fehlerhafte Bits)/(Anzahl gesendete Bits)
            BER_Anz(i,j) = sumErrors/Anzahl(i);
            

        end
    end
end

%Simulationsschleife Feste Fehlerzahl
if (Fehlerzahl ~= -1)
    for i=1:length(Fehlerzahl)
        for j=1:length(SNR)
            %Erzeuge Empfangsbits nach AWGN-Kanal
            resultBits = awgn(sourceBits, SNR(j));

            %Vergleiche gestoerte Empfangsbits mit Sendebits
            errorBits = xor(0.5*sourceBits+0.5, 0.5*sign(resultBits)+0.5);

            %Berechne BER fuer angegebene max Fehleranzahl
            k=1;
            maxAnzErrors = false;
            while ~maxAnzErrors
                if sum(errorBits(1:k)) > Fehlerzahl(i)
                    BER_Fehl(i,j) = sum(errorBits(1:k))/k;
                    maxAnzErrors = true;
                end
                k=k+1;
            end

        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der BER-Kennlinien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (Anzahl ~= -1)
    figure;
    semilogy(SNR,BER_Anz(1,:),'ro-',SNR,BER_Anz(2,:),'b*-',SNR,BER_Anz(3,:),'ms-',SNR,Pb(:),'gs-');
    grid;
    legend(strcat(num2str(Anzahl(1)), ' Bits'),...
        strcat(num2str(Anzahl(2)), ' Bits'),...
        strcat(num2str(Anzahl(3)), ' Bits'));
    title('BER fuer feste Bitanzahl');
    ylabel('BER');
    xlabel('SNR in dB');
end


if (Fehlerzahl ~= -1)
    figure;
    semilogy(SNR, BER_Fehl(1,:),'ro-',SNR,BER_Fehl(2,:),'b*-',SNR,BER_Fehl(3,:),'ms-');
    grid;
    legend(strcat(num2str(Fehlerzahl(1)), ' Fehler'),...
        strcat(num2str(Fehlerzahl(2)), ' Fehler'),...
        strcat(num2str(Fehlerzahl(3)), ' Fehler'));
    title('BER fuer feste Fehleranzahl');
    ylabel('BER');
    xlabel('SNR in dB');
end                
