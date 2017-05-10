%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   source erzeugt abhängig von signal_mode verschiedene Signale:
%       1: Si-Funktion mit Verzögerung shift und Frequenz f
%       2: Sinus-Funktion mit Frequenz f
%       3: Cosinus-Funktion mit Frequenz f
%       4: Konstante mit Ampltitude constant
%       5: Bandpasssignal
%
%   Das Signal wird unabhaengig von signal_mode zum Zeitpunkt T_ein
%   eingeschaltet und zum Zeitpunkt T_aus ausgeschaltet.
%
%   Übergebene Parameter:
%       signal_mode : Signalmodus (siehe oben)
%       f_a         : Abtastrate
%       T           : simulierte Zeitdauer
%       f0          : Frequenz der Si-, Sinus- und Cosinus-Funktion
%       T_ein       : Einschaltzeitpunkt des Signals
%       T_aus       : Ausschaltzeitpunkt des Signals
%
%   wird verwendet von: aliasing, leakage
%
% $Id$
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function signal=source(signal_mode,f_a,T,f0,T_ein,T_aus)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Verschiebung der Si-Funktion
shift=10;%seconds

% Amplitude für ein konstantes Signal (signal_mode=4)
constant=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal=cell(length(f_a), 1); % Speicher vorbelegen

% Es wird ueber alle Abtastraten f_a simuliert.
for l=1:length(f_a)
    t=0:1/f_a(l):T;

    switch signal_mode
        % 1. Funktion: Sin(sx)/sx ;s = 2 pi (t-shift)
        case 1
            signal{l}=sinc(2*f0*(t-shift));

        % 2. Funktion: Sinus mit Frequenz f
        case 2
            signal{l}=sin(2*pi*f0*t);

        % 3. Funktion: Cosinus mit Frequenz f
        case 3
            signal{l}=cos(2*pi*f0*t);

        % 4. Funktion: Konstante mit dem Wert constant
        case 4
            signal{l}=constant*ones(1,floor(T*f_a(l))+1);
        % 5. Funktion: Bandpasssignal
        case 5
            % Faktor, mit dem unterabgetastet wird
            subsample=ceil(88/f_a);
            freq = zeros(1, floor(T*f_a/2*subsample)+1); % Speicher vorbelegen
            for n=0:floor(T*f_a/2*subsample)
                f=n/T;
                if f>15.5
                    if f<=17
                        freq(n+1)=(f-15.5)/1.5;
                    elseif f<=19
                        freq(n+1)=1+(f-17)/30;
                    elseif f<=20.5
                        freq(n+1)=(20.5-f)/1.5*1.05;
                    else
                        freq(n+1)=0;
                    end
                else
                    freq(n+1)=0;
                end
            end
            
            % Lineare Phase addieren
            phase=2*pi*1i*(0:length(freq)-1)/length(freq)*1000;
            
            % Übertragungsfunktion hermitesch, damit Zeitsignal reell wird
            freq=[freq.*exp(phase) freq(end:-1:2).*exp(-phase(end:-1:2))];
            
            % Zeitsignal erzeugen
            signal{l}=ifft(freq);
            
            %unterabtasten
            signal{l}=downsample(signal{l},subsample);
            
        otherwise
            error('falscher Wert für signal_mode in der Funktion source');
    end
    
    %Signal wird zum Zeitpunkt T_ein eingeschaltet
    if ceil(T_ein*f_a(l))>0
        signal{l}(1:ceil(T_ein*f_a(l)))=zeros(1,ceil(T_ein*f_a(l)));
    end
    
    %Signal wird zum Zeitpunkt T_aus ausgeschaltet
    if floor(T_aus*f_a(l))+1<length(signal{l})
        signal{l}(floor(T_aus*f_a(l))+1:end)=zeros(1,length(signal{l})-floor(T_aus*f_a(l)));
    end
end
