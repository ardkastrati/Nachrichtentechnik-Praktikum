%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 2 - DFT
%                                                      
%   8. Faltung:
%                                                      
%       x1, y1  : Ausgangsfolgen im Zeitbereich
%       c1      : Faltung von x1 und y1
%
%       x2, y2  : Verlaengerte Folgen im Zeitbereich
%       X2, Y2  : DFT von x2, y2
%       C2      : Multiplikation von X2 und Y2
%       c2      : IDFT von C2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ausgangsfolge
x1 = [1 1 1 1 1];
y1 = [1 2 3 4 5];

% Direkte Faltung im Zeitbereich (Befehl "conv" benutzen!)
c1 = conv(x1,y1);


%%% mit Faltungtheorem (schnelle Faltung) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Faltung im Zeitbereich -> Multiplikation im Frequenzbereich

% Minimale Verlaengerung der Folgen fuer Faltungstheorem ( L1+L2-1 )
x2 = x1;
x2(8) = 0;
y2 = y1;
y2(8) = 0;

% Diskrete Fourier Transformation
X2 = fft(x2);
Y2 = fft(y2);

% Multiplikation im Frequenzberech
C2 = X2.*Y2;

% Ruecktransformation
c2 = ifft(C2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ergebnisse ausgeben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Direkte Faltung
figure('Name','Direkte Faltung im Zeitbereich')
subplot(311); stem(x1); title('x1'); xlabel('k'); axis([1 9 0 15]); grid on;
subplot(312); stem(y1); title('y1'); xlabel('k'); axis([1 9 0 15]); grid on;
subplot(313); stem(c1); title('Direkt im Zeitbereich berechnete Faltung von x1 mit x2');
xlabel('k'); axis([1 9 0 15]); grid on;

% mit Faltungstheorem
figure('Name','Faltung mit Faltungstheorem ueber den Frequenzbereich')
subplot(4,2,1); stem(x2); title('verlaengerte Folge x2');
    xlabel('k'); axis([1 9 0 15]); grid on;
subplot(4,2,2); stem(y2); title('verlaengerte Folge y2');
    xlabel('k'); axis([1 9 0 15]); grid on;
subplot(4,2,3); stem(abs(X2)); title('| DFT ( x2 ) |');
    xlabel('n'); axis([1 9 0 15]); grid on;
subplot(4,2,4); stem(abs(Y2)); title('| DFT ( y2 ) |'); 
    xlabel('n'); axis([1 9 0 15]); grid on;
subplot(4,2,5:6); stem(abs(C2)); title('| DFT ( x2 ) * DFT ( y2 ) |'); 
    xlabel('n'); axis([1 9 0 inf]); grid on;
subplot(4,2,7:8); stem(c2); title('IFFT \{ DFT ( x2 ) * DFT ( y2 ) \}'); 
    xlabel('n'); axis([1 9 0 inf]); grid on;
