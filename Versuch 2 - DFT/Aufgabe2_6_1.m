N = 8;
x = randi([-10,10],1,N) +1i*randi([-10,10],1,N);
y = fft(real(x)) + 1i*fft(imag(x));
% y = fft(x);
n = 0:1:length(x)-1;
subplot(221), stem(n,abs(y));
xlabel('Frequency, x'); ylabel('Amplitude');
title('Magnitude Spectrum');
subplot(222), stem(n,angle(y));
xlabel('Frequency, x'); ylabel('Phase');
title('Phase Spectrum');
subplot(223), stem(n,fftshift(abs(y)));
xlabel('Frequency, x'); ylabel('Amplitude');
title('Magnitude Spectrum');
subplot(224), stem(n,fftshift(angle(y)));
xlabel('Frequency, x'); ylabel('Phase');
title('Phase Spectrum');