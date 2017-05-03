function [ X ] = fft_CT(y,M)


if (M<0 || log2(M)~=floor(log2(M)))
    error('The length of the vector must be power of 2');
end
if (M == 1)
    X = y(1);
    return
end

if (M == 0)
    X = [];
    return
end

% Check length
if (length(y) > M)
    y = y(1:M);
elseif (length(y) < M)
    y(M) = 0;   % Mit Nullen auffüllen
else 
    y = y;       
end

W = exp(-1i*2*pi/M);
% Gerader Teil fft
x_gerade = y(1:M/2) + y((M/2+1):M);
x_ungerade = (y(1:M/2) - y((M/2+1):M));
for i = 1:M/2
    x_ungerade(i)= x_ungerade(i)*W^(i-1);
end

X_gerade = fft_CT(x_gerade,M/2);
X_ungerade = fft_CT(x_ungerade,M/2);

X = zeros(size(y));
for i=1:M/2
    X(2*i-1)= X_gerade(i);
    X(2*i)= X_ungerade(i);
end

    
end

