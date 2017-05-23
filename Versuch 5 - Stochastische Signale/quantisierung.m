%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 6 - Stochastische Signale
%
%   Quantisierungsrauschen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%% Parameter

% Anzahl der Elemente
N = 1000;
% Wortlaenge des Quantisierers (in Bits)
res  = 8;
% Quantisierungsstufen
D_x = 2 ^ res;


%% Berechungen

% Zufallsdaten
x = rand(1, N) - 0.5;
% Quantisierung
Q_x = (round(x * D_x - 0.5) + 0.5) / D_x;
% Quantisierungsfehler
e = Q_x - x;

% Leistungsbetrachtung
P_x = mean(x.*x);
P_e = mean(e.*e);
SNR = 10*log10(P_x/P_e);


%% Plot

figure('Name', 'Quantisierung')

plot(x,'b-'); hold on;
plot(Q_x,'r.');

xlim([0 100])
xlabel('Index'); ylabel('Wert'); grid on;
legend('ursprünglicher Prozess', 'quantisierter Prozess');
