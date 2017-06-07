%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   6. Zyklische Blockcodes 2
%   6.2 - Übertragung mit zyklischem Blockcode                                                      
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Anzahl der simulierten Bits
Anzahl = 21;

%Länge Infowort
k= 3;

%Länge Codewort
n= 7;

% (7,3)-Code mit g(x) = 1 + x^2 + x^3 + X^4
G = [1 0 0 1 1 1 0; 0 1 0 0 1 1 1; 0 0 1 1 1 0 1];

load fehlermuster2.mat '-mat';
load buendel_fehlervektoren.mat '-mat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Variablen initialisieren
i=0;

%Erzeuge Infobits
sourceBitsInt = [1 0 1; 1 0 0; 0 0 0; 0 0 1; 1 1 1; 1 1 1; 1 0 0];

%Encoder

%Erzeuge Eingangsmatrix fuer Schieberegister [<Infowort> 0 0 0];
codewordsInit = [sourceBitsInt zeros(ceil(Anzahl/k),(n-k))];

%Erzeuge Speicherzustaende im Schieberegister
registerState = zeros(ceil(Anzahl/k),(n-k));

%Erzeuge ParityBits mittels Schieberegister
for i=1:n
    registerState = [mod((codewordsInit(:,i)+(registerState(:,4))),2) registerState(:,1) mod((registerState(:,2)+registerState(:,4)),2) mod((registerState(:,3)+registerState(:,4)),2)];
end

%Erzeuge Codewort durch Zusammensetzen von Infowort und Endzustaenden des
%Registers
codedBits = [sourceBitsInt(:,:) registerState(:,((n-k):-1:1))];

%NRZ-Codierung der Sendebitfolge
codedBitsNRZ = sign(codedBits - 0.5);

%Erzeuge Empfangsbits mittels Fehlermuster
for i=1:Anzahl/k
    noisedBitsCoded(i,:) = codedBitsNRZ(i,:) .* fehlermuster(i,:);
end

%Entscheider im Empfaenger
decidedCodedBits = (sign(noisedBitsCoded)+1)/2;

%Decoder

%Erzeuge ParityCheckMatrix H(x)
H = [G(:,(k+1):n)' diag(ones(1, (n-k)))];

%berechne Syndrom
synd = mod((decidedCodedBits(:,:) * H'),2);

%Suche Fehlermuster, entsprechend ermitteltem Syndrom
fehlerNr = bin2dec(num2str(synd));

%korrigiere Empfangswort entsprechend dem angenommenem Fehlermuster
for i=1:(Anzahl/k)
    decidedCodedBitsKorr(i,:) = mod(decidedCodedBits(i,:) + buendel_fehlervektoren(fehlerNr(i)+1,:),2);
end

%erzeuge Infowort durch Abschneiden der Paritybits
decodedBits = decidedCodedBitsKorr(:,1:k);

%Vergleiche gestoerte (decodierte) Empfangsbits mit uncodierten Sendebits
errorsCoded = abs(decodedBits - sourceBitsInt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Darstellung: Infobits Sendereingang
sourceBitsInt
%Darstellung: Empfängerausgang
decodedBits

%Darstellung: Codebits Encoderausgang
codedBits
%Darstellung: Codebits Decodereingang 
decoderEingang = (sign(noisedBitsCoded)+1)/2
%Darstellung: Fehlermuster
fehlermuster
