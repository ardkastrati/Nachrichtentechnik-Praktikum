%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Kanalcodierung 
%                                                      
%   7. Faltungscodierung mit Schieberegister
%   7.2 - Übertragung mit zyklischem Blockcode                                                      
%                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Anzahl der Ausgabe-Bits
Anzahl = ;      %Durch den Studenten anzupassen


% Belegung der einzelnen Regsiterpfade fuer 1. und 2. Codebit
% y1 und y2 geben die Verknüpfung für Codebit y1 bzw. y2 nach der
% Konvention y1 = [x^3 x^2 x 1] an. 
% z.B.: y1 = [1 0 0 1] für y1=x^3+1

y1 = [ ];       %Durch den Studenten anzupassen
y2 = [ ];       %Durch den Studenten anzupassen


%Eingangsbitfolge
sourceBitsInt = [ ];     %Durch den Studenten einzugeben


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Variablen initialisieren
i=0;


%Encoder

%Erzeuge Speicherzustaende im Schieberegister
registerState = zeros(1,length(y1)-1);

%Berechne Ausgangsdatenfolge y

for i=1:length(sourceBitsInt)
    %Berechne Codebits y1 und y1
    codedBits(2*i-1) = mod([registerState sourceBitsInt(i)]*y1',2);
    codedBits(2*i) = mod([registerState sourceBitsInt(i)]*y2',2);
     
    %Verschiebe Belegung des Schieberegisters incl. aktuellem Eingangsbit. 
    registerState_aux = circshift([registerState sourceBitsInt(i)],[0,-1]);
    registerState = registerState_aux(1:length(registerState));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der codierten Bits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;

stem(codedBits, 'filled');

title('Faltungscodierung mittels Schieberegister');
legend('Codebits'); 
