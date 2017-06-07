%CRC Demonstrationsprogramm...

%clc
clear all
%close all
AnzBits=100;   % Wie viele Bits pro CRC Block
AnzRun= 2000;  % Wie viele Blöcke werden simuliert
Burst=0;       % Burst = 0 : Einzelfehler werden simuliert
               % Burst = 1 : Bündelfehler werden simuliert
         
% GenPoly=[1 x^1 x^2 x^3 ...] ohne höchste Potenz!

 %GenPoly=[1];                     % (x+1)
% GenPoly=[1 0];                   % (1+x)(1+x)
% GenPoly=[1 1 0 0];               % CRC-4
% GenPoly=[1 0 1 0 1];             % CRC-5-ITU
%  GenPoly=[1 0 1 0 0];             % CRC-5 USB
% GenPoly=[1 1 0 0 0 0];           % CRC-6 ITU
% GenPoly=[1 0 0 1 0 0 0];         % CRC-7
% GenPoly=[1 0 1 1 0 0 0 1];       % 1-WIRE Bus               
GenPoly=[1 0 0] % (x^3+1) 
for N=1:10    % Schleife über 1..10 Fehler

    errAnz=0;
    for k=1:AnzRun

        % Beginne CRC-Berechnung ...
        State=  zeros(1,length(GenPoly));       % Startbelegung des Registers
        %Data=randint(1,AnzBits);                % randint is deprecated
        Data=randi([0 1],1,AnzBits);             % Zufällige Sendedaten
        Input=[Data, zeros(1,length(GenPoly))]; % Nullen in der Länge des Schieberegisters anhängen 
        
        %===DEBUG Datenfolgen ====%
        %Data=  [1 0 0 1 1 0 1 0 1 1]; % Eingangsfolge
        %Input=  [1 0 1 0 0 0 1 0];
        %Input=   [0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0];
        %Input=   [0 1 0 1 0 1 1 1 1 0 1 0 0 0 1 0]; 
        %Data= [1 1 0 1 0 1 1 1]
        %Input=[Data, zeros(1,8)];
        %Input=[Data, 0 0 0 0 0 0 0 0];
        %========================%
        
        for l = 1 :length(Input);            % Schiebe alle Inputwerte durch das Register
            back=State(end).*GenPoly;
            shift=[Input(l),State(1:end-1)]; % State geschoben und neuen Wert eingefügt
            State=mod(back+shift,2);
        end

        % richtige Reihenfolge beim Auslesen des Schieberegisters...
        for l=1:length(State)
            crc_value(l)=State(end+1-l);
        end

        Send=[Data,crc_value];               % Sendedatenfolge
        
        % Kanal mit Fehlern...
        if Burst == 0 % manipuliere N zufällige Bits...
            %err=randint(1,N,length(Send)-1)+1;  % randint is deprecated
            err=randi([0 (length(Send)-2)],1,N)+1;  % An diesen Stellen werden Bits gekippt
            for i=1:length(err)
                Send(err(i))=not(Send(err(i)));
            end
        end
        
        if Burst == 1 % manipuliere M Bits hintereinander...
            %pos=randint(1,1,length(Send)-1-N); % randint is deprecated
            pos=randi([0 length(Send)-2-N],1,1); % Wähle zufälligen Startpunkt des Bündelfehlers aus
            sendalt=Send;
            Send(pos+1)=not(Send(pos+1));      % Erstes Bit des Bursts muss falsch sein
            if N~=1                            % Sonst 
                Send(pos+N)=not(Send(pos+N));      % Letztes Bit muss falsch sein
            end
            for n=2:N-1
                if randi([0 1],1,1)
                    Send(pos+n)=not(Send(pos+n));
                end
            end
        end
        
        % Prüfung auf Fehler
        State=zeros(1,length(GenPoly));
        Input=Send;
        for k = 1 :length(Input); % schiebe alle Inputwerte durch das Register
            back=State(end).*GenPoly;
            shift=[Input(k),State(1:end-1)]; % State geschoben und neuen Wert eingefügt
            State=mod(back+shift,2);
        end

        if sum(State)==0
            %    disp('Fehlerfreie Übertragung!')
        end

        if sum(State)~=0
            %    disp('Fehlerhafte Übertragung!')    
            errAnz=errAnz+1;
        end
    end

    %Fehlererkennungsrate:
    FER(N)=errAnz/AnzRun;
end

% Plotte Ergebnis
figure
stem(FER);
if Burst==0
    xlabel('Anzahl Fehler');
else
    xlabel('Länge des Burstfehlers');
end
ylabel('Fehlererkennungswahrscheinlichkeit')
FER
