function A = exponent(p,g,a)   
%p=13;
%g=3;
%a=11;
%Berechne Exponent A=g^a mod p
%Umwandlung a von dec nach bin
l=[];
rest=[];
temp=dec2bin(a);
for i=1:length(temp)
    l(i)=str2num(temp(i));
end
%l
rest(1)=g;
for i=2:length(l)
    rest(i)=mod(rest(i-1)^2,p);
end
%rest
prd=1;
for i=1:length(l)
     prd=rest(length(l)-i+1)^l(i)*prd;
   
end
A=mod(prd,p);