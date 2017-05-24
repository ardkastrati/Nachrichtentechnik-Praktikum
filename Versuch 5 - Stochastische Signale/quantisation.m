% Quantisierung des Eingangssignals y mit N Bits
% ----------------------------------------------
% Das Eingangssignal wird zunächst auf 1 normiert und dann im
% Intervall [-1 1] quantisiert mit Kommazahlen, die N Bits entsprechen,
% d.h. es entstehen 2^N Quantisierungsstufen.
%
% Benjamin Nuss, 26.09.2013

function [ y_quant ] = quantisation( y, N )

% Normierung
if max(abs(y)) ~= 0
    y = y/max(abs(y)+10^(-40));
end

[dim1, dim2] = size(y);

% Quantisierung
y_quant = zeros(dim1, dim2);

for i = 1:length(y)
    if y(i) >= 0
        y_quant(i) = (round((y(i)+1/(2^N))*(2^N)/2)*2-1)/(2^N);
    else
        y_quant(i) = (round((y(i)-1/(2^N))*(-(2^N)/2))*2-1)/(-(2^N));
    end
end

% for i = 1:length(y)
%     if y(i) >= 0
%         y_quant(i) = round((y(i)+1/(2^N-1))*(2^N-1)/2)/(2^N-1)*2-1/(2^N-1);
%     else
%         y_quant(i) = round((y(i)-1/(2^N-1))*(-(2^N-1)/2))/(-(2^N-1))*2+1/(2^N-1);
%     end
% end

end