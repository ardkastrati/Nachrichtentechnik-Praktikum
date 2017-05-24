% NTP - Stochastische Signale - Quantisierung von Audiosignalen (A5)

close all
clear all
clc

%% Erzeugen des Audiosignals

% Quelle w�hlen
% source = 1: Sinusschwingung bei f = 440 Hz (Kammerton A)
% source = 2: Audiosignal
% source = 3: wei�es gleichverteiltes Rauschen
source = 1;

T = 5; % Zeitdauer T des ausgegebenen Audiosignals in Sekunden

if source == 1
    SampRate = 44100; % Abtastrate in Hz
    Samples = T*SampRate+1;
    f = 440; % Frequenz der Sinusschwingung
    
	y = 1*sin(2*pi*f/SampRate*(0:Samples));
elseif source == 2
    [y_stereo, SampRate] = audioread('kate_yanai_bacardi_feeling_kurz.wav');

    y = y_stereo(:,1);
else
    SampRate = 44100; % Abtastrate in Hz
    y = -1+2*rand(T*SampRate,1);        
end

% Normiering von y
y = y/max(abs(y));


%% Quantisierung
B =2; % Anzahl der Quantisierungsbits

y_quant = quantisation(y,B);

e = y-y_quant; % Berechnen des Quantisierungsfehlers


%% Berechnung des Quantisierungsrauschens
P_s = var(y)

P_q = var(e)

snr_db = 10*log10(P_s/P_q)


%% Erstellen des Periodogramms
fft_length = 2^12; % Länge der FF

N_mean = 50;


% Spektrum des Originalsignals
Y_fft_matrix = zeros(N_mean,fft_length);

for i = 1:N_mean
    Y_fft_matrix(i,:) = fft(y((i-1)*fft_length+1:i*fft_length));
end

Y_fft = mean(abs(Y_fft_matrix));


% Spektrum des quantisierten Signals
Y_quant_fft_matrix = zeros(N_mean,fft_length);

for i = 1:N_mean
    Y_quant_fft_matrix(i,:) = fft(y((i-1)*fft_length+1:i*fft_length));
end

Y_quant_fft = mean(abs(Y_quant_fft_matrix));


% Spektrum des Quantisierungsrauschens
E_fft_matrix = zeros(N_mean,fft_length);

for i = 1:N_mean
    E_fft_matrix(i,:) = fft(e((i-1)*fft_length+1:i*fft_length));
end

E_fft = mean(abs(E_fft_matrix));


%% Grafische Ausgabe

figure(1)
plot(2^14:2^14+2^10-1, y(2^14+1:2^14+2^10),'b-')
hold on
grid on
plot(2^14:2^14+2^10-1, y_quant(2^14+1:2^14+2^10),'r--')
legend('Originalsignal','quantisiertes Signal')
xlabel('Samples')
xlim([2^14 2^14+2^10-1])
ylim([-1.1 1.1])
hold off

figure(2)
subplot(1,2,1)
plot(0:(SampRate/fft_length):(SampRate/fft_length)*(128-1), abs(Y_fft(1:128)))
xlabel('f in Hz')
title('Spektrum des Audiosignals')
grid on

subplot(1,2,2)
plot(0:(SampRate/fft_length):(SampRate/fft_length)*(128-1), abs(E_fft(1:128)))
xlabel('f in Hz')
title('Spektrum des Quantisierungsrauschens')
grid on

[y_hist, y_hist_x] = hist(y,20);
[e_hist, e_hist_x] = hist(e,20);

y_wkeit = y_hist/length(y)/(y_hist_x(2)-y_hist_x(1));
e_wkeit = e_hist/length(e)/(e_hist_x(2)-e_hist_x(1));

figure(3)
subplot(1,2,1)
bar(y_hist_x, y_wkeit)
title('Wahrscheinlichkeitsverteilung des Audiosignals')

subplot(1,2,2)
bar(e_hist_x, e_wkeit)
title('Wahrscheinlichkeitsverteilung des Quantisierungsrauschens')

%% Ausgabe des Audiosignals

sound(y_quant(1:T*SampRate),SampRate);

clear playsnd