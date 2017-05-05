clear
N = 10000;
x = randi([0 1],1,N);
for i=1:N
    if x(i)== 0
        c(i) = -1;
    else
        c(i) = 1;
    end
end
c(x==1)=1;
c(x~=1)=-1;

n = randn(1,N);

s = n + c;

SNR_dB = 10*log10(sum(c.^2)/sum(n.^2));

% Aufgabe 5.3
r = s>0;

BER = sum(r~=x)/N;

% Aufgabe 5.4
SNR_dB = [-4:1:12];
SNR_lin = 10.^(SNR_dB/10);
rauschleistung = 1./SNR_lin;

for i=1:length(rauschleistung)
    
    n = sqrt(rauschleistung(i))*randn(1,N);

    s = n + c;

    %SNR_dB = 10*log10(sum(c.^2)/sum(n.^2));
    r = s>0;
    BER_neu(i) = sum(r~=x)/N;
end
BER_neu_db=10*log10(BER_neu);
plot(SNR_dB,BER_neu_db)
    
