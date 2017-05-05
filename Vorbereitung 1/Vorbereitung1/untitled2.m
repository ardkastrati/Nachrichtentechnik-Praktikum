function [ X ] = fft_CT(y, M)

if(M == 1) 
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
   
nextPower = 2^(ceil(log2(M)));

if(nextPower ~= M) 
    x(nextPower) = 0;
end

M = nextPower;
W = exp(-1i*2*pi/M);

%gerade Teil
x_gerade = x(1:(M/2)) + x((M/2 + 1):M);
for i = 1:M/2
    x_ungerade = (x(1:(M/2)) - x((M/2 + 1):M))*(W^i);


X_gerade = fft_CT(x_gerade, M/2);
X_ungerade = fft_CT(x_ungerade, M/2);  


for i = 1:M/2 
    X(2*i - 1) = X_gerade(i);
    X(2*i) = X_ungerade(i);
end


end

