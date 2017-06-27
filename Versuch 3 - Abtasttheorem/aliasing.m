% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 3 - Abtasttheorem
%
%   aliasing: Unterschiedliche Signale werden abgetastet und durch
%   Rekonstruktion im Zeitbereich wiedergewonnen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulationsparameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Vektor der Abtastraten
f_a=[0.5 1 33];%[4 2 1 0.5];%Hz - bitte vervollstaendigen Sie diesen Vektor!;

%simulierte Zeitdauer
T=25;%seconds (20)

% Signalmodus
signal_mode=1;%(1)

% Frequenz der Si-, Sinus- und Cosinus-Funktion
f0=1/3;%Hz

% Einschaltzeitpunkt des Signals
T_ein=5;%seconds (0)

% Ausschaltzeitpunkt des Signals
T_aus=20;%seconds

% Anzahl der Werte in den Graphen
N=1000;

% Hoechste dargestellte Frequenz
fg=1.5;%Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Erzeugung des abgetasteten Signals
signal=source(signal_mode,f_a,T,f0,T_ein,T_aus);

%Rekonstruktion des Signals aus den Abtastwerten
recon=time_recon(signal,f_a,T,N);

% Spektrum des rekonstruierten Signals
[f,signal_frequency]=spectrum(signal,f_a,fg,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der Simulationsergebnisse im Zeitbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Zeitbereich');

colors=['r' 'b' 'g' 'k' 'c' 'm' 'y'];
markers=['+' 'o' '*' 'x' 's' 'd' '^'];

% Darstellen der Abtastwerte
for l=1:length(f_a)    
    t=0:1/f_a(l):T;
    stem(t,signal{l},[colors(mod(l,length(colors))) markers(mod(l,length(markers)))],'MarkerSize',10);
    hold on;
    
    % Eintragungen der Legende
    if l==1
        l_str=['f_a=' num2str(f_a(1))];
    else
        l_str=str2mat(l_str, ['f_a=' num2str(f_a(l))]);
    end
end

percentage = zeros(length(f_a));
%Darstellen der rekonstruierten Signale
for l=1:length(f_a)    
    t=(0:N-1)/N*T;
    plot(t,recon{l},colors(mod(l,length(colors))));
    percentage(l) = (max(recon{l})-1);
    hold on;
end

% t=(0:N-1)/N*T;
% error = recon{1}-sinc(2*f0*(t-10));
% plot(t,error,'k','LineWidth',2);

grid on;
xlabel('Zeit in s');
ylabel('Amplitude');
%Darstellen der Legende
legend(l_str);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ausgabe der Simulationsergebnisse im Frequenzbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Frequenzbereich');

%Darstellen der rekonstruierten Signale
for l=1:length(f_a)
    plot(f{l},signal_frequency{l},colors(mod(l,length(colors))));
%     (max(signal_frequency{l})-6)/6;
    hold on;
end

grid on;
xlabel('Frequenz in Hz');
ylabel('Amplitude');
axis([-fg fg -Inf Inf]);
%Darstellen der Legende
legend(l_str);
