%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   3. Übertragung mit Blockcode
%   Aufgabe 3.2                                                      
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all;
%close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Anzahl der simulierten Bits
Anzahl = 1000000;

%Signal-zu-Rausch-Verhaeltnis
%SNR = [Startwert:Inkrement:Endwert];
SNR = 4 :1 : 10;

%Länge Infowort
k = 4;

%Länge Codewort
n = 15;

%Generatormatrix
%Durch den Studenten auszuwählen
% G = [1 0 0 0 1 0 1; 0 1 0 1 1 0 0; 0 0 1 1 0 0 1];    %erster (7,3) Code
% G = [1 0 0 1 1 0 0; 0 1 0 0 1 1 0; 0 0 1 1 1 1 1];    %zweiter (7,3) Code
% G = [1 0 0 1 0 1 1; 0 1 0 1 1 0 1; 0 0 1 1 1 1 0];    %dritter (7,3) Code

%G = [1 0 1 0 1 1 1 1; 0 1 0 1 0 1 1 1];               %(8,2) Code
G = [1 0 0 0 0 0 0 0 1 1 1 1 1 1 1; 0 1 0 0 0 1 1 1 0 0 0 1 1 1 1; 
     0 0 1 0 1 0 1 1 0 1 1 0 0 1 1; 0 0 0 1 1 1 0 1 1 0 1 0 1 0 1];  %(15,4) Code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assert(~isnan(Anzahl) && ~isnan(SNR) && ~isnan(k) && ~isnan(n), ...
%    'Bitte Simulationsparameter eintragen' ...
%)
%assert(exist('G','var'), 'Bitte Generatormatrix auswählen')

%Erzeuge Random Bits
sourceBitsInt = randi([0,1],ceil(Anzahl/k),k);

%Encoder
codedBits = encode(sourceBitsInt, n, k, 'linear', G);

%NRZ-Codierung der Sendebitfolge
codedBitsNRZ = sign(codedBits - 0.5); clear codedBits % Speicher sparen

% Faire Normierung, Eb/N0 konstant
codedBitsNRZ = codedBitsNRZ*sqrt(k/n);


%Simulationsschleife
BER_Coded = zeros(1,length(SNR));
for i=1:length(SNR) 
    %Erzeuge Empfangsbits nach AWGN-Kanal
    noisyBitsCoded = awgn(codedBitsNRZ, SNR(i),'measured'); 
    
    %Entscheider im Empfaenger
    decidedCodedBits = (sign(noisyBitsCoded)+1)/2; clear noisyBitsCoded
    
    %Decoder
    decodedBits = decode(decidedCodedBits,n,k,'linear',G); clear decidedCodedBits
    
    %Vergleiche gestoerte (decodierte) Empfangsbits mit uncodierten Sendebits
    sumErrorsCoded = sum(sum(abs(decodedBits - sourceBitsInt))); clear decodedBits

    %BER = (Anzahl fehlerhafte Bits)/(Anzahl gesendete Bits)
    BER_Coded(i) = sumErrorsCoded / Anzahl;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der BER-Kennlinien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure;
semilogy(SNR,BER_Coded(1,:),'rs-');
title('BER fuer codierte Uebertragung');
xlabel('Eb/N0')
ylabel('BER')
