%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   spectrum berechnet den Betrag der Diskreten Fouriertransformation.
%   Durch Zero-Padding wird die Auflösung erhöht.
%
%   Übergebene Parameter:
%       signal      : Signal im Zeitbereich
%       f_a         : Abtastrate
%       fg          : Hoechste dargestellte Frequenz
%       N           : Anzahl der erzeugten Abtastwerte
%
%   wird verwendet von aliasing, leakage, bandpass_subsampling
%
% $Id$
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f,signal_frequency]=spectrum(signal,f_a,fg,N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Speicher vorbelegen
f = cell(length(f_a), 1);
signal_frequency = cell(length(f_a), 1);

%Es wird ueber alle Abtastraten f_a simuliert
for l=1:length(f_a)
    
    % Zero-Padding
    signal{l}=[signal{l} zeros(1,N-length(signal{l}))];
    
    %Betrag der Diskreten Fouriertransmformation
    signal_frequency{l}=abs(fft(signal{l}));

    %Anzahl der Perioden des Signals im Frequenzbereich bis zur Frequenz f0
    periods=ceil(2*fg/f_a(l));
    signal_frequency{l}=repmat(signal_frequency{l},1,periods);

    %Niedrige Frequenzen in die Mitte verschieben
    signal_frequency{l}=circshift(signal_frequency{l},[0 round(length(signal_frequency{l})/2)]);
    
    f{l}=(-N/2*periods:N/2*periods-1)/N*f_a(l);
end
