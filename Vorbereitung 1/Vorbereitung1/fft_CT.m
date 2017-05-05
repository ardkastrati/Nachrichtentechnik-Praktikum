%This function calculates the fft of an array if the specified length (M)
%is a power of 2. Otherwise it throws an exception. Zero padding/array cut
%is used, if the array doesn't match the the specified length M.

function [ X ] = fft_CT(y,M)

if (M<0 || log2(M)~=floor(log2(M)))
    error('The length of the vector must be a power of 2');
end

if (M == 0)
    X = [];
    return
end

if (M == 1)
    X = y(1);
    return
end

% check the length
if(length(y) > M) 
    x = y(1:M);
elseif(length(y) < M) 
    x(M) = 0;
else 
       x = y;
end

%Cooley-Tukey with recursion
W = exp(-1i*2*pi/M);

x_gerade = x(1:M/2) + x((M/2+1):M);
x_ungerade = (x(1:M/2) - x((M/2+1):M));

for i = 1:M/2
    x_ungerade(i)= x_ungerade(i)*W^(i-1);
end

X_gerade = fft_CT(x_gerade,M/2);
X_ungerade = fft_CT(x_ungerade,M/2);

X = zeros(size(x));
for i=1:M/2
    X(2*i-1)= X_gerade(i);
    X(2*i)= X_ungerade(i);
end
end