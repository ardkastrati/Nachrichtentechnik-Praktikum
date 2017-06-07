%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   5. Zyklische Blockcodes
%   5.4 - Übertragung mit zyklischem Blockcode                                                      
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
SNR = [Startwert:Inkrement:Endwert];        %Durch den Studenten anzupassen

%Länge Infowort
k= 4;

%Länge Codewort
n= 7;

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

%Erzeuge Eingangsmatrix fuer Schieberegister [<Infowort> 0 0 0];
codewordsInit = [sourceBitsInt zeros(ceil(Anzahl/k),(n-k))];

%Erzeuge Speicherzustaende im Schieberegister
registerState = zeros(ceil(Anzahl/k),(n-k));

%Erzeuge ParityBits mittels Schieberegister
for i=1:n
    registerState = [mod((codewordsInit(:,i)+(registerState(:,3))),2) mod((registerState(:,1)+registerState(:,3)),2) registerState(:,2)];
end

%Erzeuge Codewort durch Zusammensetzen von Infowort und Endzustaenden des
%Registers
codedBits = [sourceBitsInt(:,:) registerState(:,(3:-1:1))];

%NRZ-Codierung der Sendebitfolge
codedBitsNRZ = sign(codedBits - 0.5);


%Erzeuge ParityCheckMAtrix H(x)
H4 = [G4(:,(k+1):n)' diag(ones(1, (n-k)))];

%Simulationsschleife

for j=1:length(SNR) 
    %Erzeuge Empfangsbits nach AWGN-Kanal
    noisedBitsCoded = awgn(codedBitsNRZ, SNR(j),'measured');
    
    %Entscheider im Empfaenger
    decidedCodedBits = (sign(noisedBitsCoded)+1)/2;
    
    %Decoder
    
    %berechne Syndrom
    synd = mod((decidedCodedBits(:,:) * H4'),2);
    
    %Hilfsvariablen
    syndNRZ = sign(synd - 0.5);
    H4NRZ = sign(H4 - 0.5);
    decidedCodedBitsKorr = decidedCodedBits;
    
    %bestimme Fehlermuster:
    %Suche Spalte in H, die dem Syndrom entspricht für jedes Codewort
    for i=1:(Anzahl/k)
     
        [row, col] = find((syndNRZ(i,:) * H4NRZ)==(k-1));
        
        %korrigiere Bits aufgrund von Syndrom-Bestimmung in jeweiligem
        %Codewort
        decidedCodedBitsKorr(i,col) = mod((decidedCodedBits(i,col) + 1),2);
    end
        
    %erzeuge Infowort durch Abschneiden der Paritybits
    decodedBits = decidedCodedBitsKorr(:,1:k);
    
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
semilogy(SNR,BER_Coded(1,:),'ko-');
title('BER fuer codierte Uebertragung');
