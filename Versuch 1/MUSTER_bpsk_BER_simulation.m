n_bits = 100000; % Anzahl simulierter Bits 
SNR_dB = -4:0.1:12; %Simulierter SNR Bereich 
BER = zeros(1,length(SNR_dB)); %Ergebnisvektor 
 
for k = 1:length(SNR_dB) 
    disp('SNR = ') %Fortschrittsanzeige in Konsole 
    disp(SNR_dB(k))
     
    %BPSK-Signal Generierung 
    bits_tx = randi([0,1],n_bits,1); 
    signal_tx = 2*bits_tx-1; 
     
    %Rauschen 
    noise = sqrt(db2pow(-SNR_dB(k))).*randn(n_bits,1); 
     
    %AWGN-Kanal => Empfangssingal = Signal + Rauschen 
    signal_rx = signal_tx + noise; 
     
    %Demodulation 
    bits_rx = (sign(signal_rx)+1)/2; 
     
    %Fehlerberechnung 
    error_vector = abs(bits_rx-bits_tx); 
    BER(k) = sum(error_vector)/n_bits;    
end 
 
semilogy(SNR_dB, BER);
grid minor
title('Bit Error Rate over SNR')
xlabel('SNR [dB]')
ylabel('BER')
