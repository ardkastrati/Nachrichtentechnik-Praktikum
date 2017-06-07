%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   2. Vergleich codierter und uncodierter Übertragung
%                                                      
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Abbruch der Simulation nach
Anzahl = NaN; %simulierten Bits

%Signal-zu-Rausch-Verhaeltnis
%SNR = [Startwert:Inkrement:Endwert];
SNR = NaN: NaN: NaN;

%Länge Infowort
k = NaN;

%Länge Codewort
n = NaN;

%Generatormatrix
G = [1 0 0 0 0 1 1; 0 1 0 0 1 0 1 ; 0 0 1 0 1 1 0; 0 0 0 1 1 1 1];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assert(~isnan(Anzahl) && ~isnan(SNR) && ~isnan(k) && ~isnan(n), ...
%    'Bitte Simulationsparameter eintragen' ...
%)

%Variablen initialisieren
i=0;

%Erzeuge Random Bits
sourceBitsInt = randi([0,1],Anzahl/k,k);

%Encoder
codedBits = encode(sourceBitsInt, n, k, 'linear/binary', G);

%NRZ-Codierung der Sendebitfolge
codedBitsNRZ = sign(codedBits - 0.5);
sourceBitsNRZ = sign(sourceBitsInt - 0.5);

% Faire Normierung, Eb/N0 konstant
codedBitsNRZ = codedBitsNRZ*sqrt(k/n);

% Ergebnis-Variablen initialisieren
BER_Uncoded = zeros(1,length(SNR));
BER_Coded   = zeros(1,length(SNR));

%Simulationsschleife
for j=1:length(SNR) 
    %Erzeuge Empfangsbits nach AWGN-Kanal
    noisyBitsUncoded = awgn(complex(sourceBitsNRZ),SNR(j));
    noisyBitsCoded = awgn(complex(codedBitsNRZ), SNR(j));
    
    %Entscheider im Empfaenger
    decidedUncodedBits = (sign(real(noisyBitsUncoded))+1)/2;
    decidedCodedBits = (sign(real(noisyBitsCoded))+1)/2;
    
    %Decoder
    decodedBits = decode(decidedCodedBits,n,k,'linear',G);
    
    %Vergleiche gestoerte (decodierte) Empfangsbits mit uncodierten Sendebits
    errorsUncoded = abs(decidedUncodedBits - sourceBitsInt);
    errorsCoded = abs(decodedBits - sourceBitsInt);

    %Anzahl der Einsen im Verktor errorsCoded entspricht Anzahl der
    %Uebertragungsfehler
    sumErrorsUncoded = sum(sum(errorsUncoded));
    sumErrorsCoded = sum(sum(errorsCoded));

    %BER = (Anzahl fehlerhafte Bits)/(Anzahl gesendete Bits)
    BER_Uncoded(j) = sumErrorsUncoded / Anzahl;
    BER_Coded(j) = sumErrorsCoded / Anzahl;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der BER-Kennlinien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
semilogy(SNR,BER_Uncoded(1,:),'ro-',SNR,BER_Coded(1,:),'b*-');
grid;
title('BER fuer codierte / uncodierte Uebertragung');
xlabel('Eb/N0')
ylabel('BER')
