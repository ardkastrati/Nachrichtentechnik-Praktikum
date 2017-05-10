% $Id$
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   time_recon rekonstruiert ein Signal im Zeitbereich aus seinen
%   Abtastwerten, indem jeder Abtastwert durch eine Si-Funktion ersetzt
%   wird.
%
%   Übergebene Parameter:
%       signal      : Abtastwerte
%       f_a         : Abtastrate
%       T           : simulierte Zeitdauer
%       N           : Anzahl der erzeugten Werte
%
%   wird verwendet von aliasing
%
% $Id$
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function recon=time_recon(signal,f_a,T,N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recon=cell(length(f_a), 1);

for l=1:length(f_a)

    recon{l}=zeros(1,N);
    t=(0:N-1)/N*T;

    for k=0:T*f_a(l)-1
        recon{l}=recon{l}+sinc(t*f_a(l)-k)*signal{l}(k+1);
    end
end
