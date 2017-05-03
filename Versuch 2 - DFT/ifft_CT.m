function [ X ] = ifft_CT(y,M)

[a,b] = size(y);
if (a > b)
    x = circshift(flipud(y),1,1);
else
     x = circshift(fliplr(y),1,2);
end
   

end

