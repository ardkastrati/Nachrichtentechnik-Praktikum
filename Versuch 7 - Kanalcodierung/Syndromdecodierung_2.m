%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   5. Zyklische Blockcodes
%   5.3 - Blockcodierung mit Generatormatrix                            
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all;
%close all;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Abbruch der Simulation nach

% - Anzahl der simulierten Bits
Anzahl = ;      %Durch den Studenten anzupassen


%Signal-zu-Rausch-Verhaeltnis
SNR = [Startwert:Inkrement:Endwert]; %Durch den Studenten anzupassen

%Länge Infowort
k= 4;

%Länge Codewort
n= 7;

%Generatormatrix
% (7,4)-Code mit g(x) = 1 + x + x^3
G4 = [1 0 0 0 1 0 1; 0 1 0 0 1 1 1; 0 0 1 0 1 1 0; 0 0 0 1 0 1 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Variablen initialisieren
i=0;

%Erzeuge Random Bits
sourceBitsInt = randi(1,ceil(Anzahl/k),k);

%Encoder
codedBits = encode(sourceBitsInt, n, k, 'linear', G4);

%NRZ-Codierung der Sendebitfolge
codedBitsNRZ = sign(codedBits - 0.5);


%Simulationsschleife

for j=1:length(SNR) 
    %Erzeuge Empfangsbits nach AWGN-Kanal
    noisedBitsCoded = awgn(codedBitsNRZ, SNR(j),'measured');
    
    %Entscheider im Empfaenger
    decidedCodedBits = (sign(noisedBitsCoded)+1)/2;
    
    %Decoder
    decodedBits = decode(decidedCodedBits,n,k,'linear',G4);
    
    %Vergleiche gestoerte (decodierte) Empfangsbits mit uncodierten Sendebits
    errorsCoded = abs(decodedBits - sourceBitsInt);

    %Anzahl der Einsen im Verktor errorsCoded entspricht Anzahl der
    %Uebertragungsfehler
    sumErrorsCoded = sum(sum(errorsCoded));

    %BER = (Anzahl fehlerhafte Bits)/(Anzahl gesendete Bits)
    BER_Coded(j) = sumErrorsCoded / Anzahl;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der BER-Kennlinien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure;
semilogy(SNR,BER_Coded(1,:),'r*-');
title('BER fuer codierte Uebertragung');
 
