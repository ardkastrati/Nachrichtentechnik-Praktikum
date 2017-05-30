% Demonstration der Huffman Codierung
        

clear all
for N=1:10
load huffman.mat                  % Text in Variable d

%Umwandlung von Zeichen zu Bits...
temp=dec2bin(d);
[a,b]=size(temp);
d=reshape(temp',1,a*b);           %Nun als "Bit-String"
d=d(1:floor(length(d)/N)*N);

symbol={};
for n=0:2^N-1
    symbol{n+1}=dec2bin(n,N);
end

p=[];
sym={};
for i=1:length(symbol)
    k=findstr(d,symbol{i});       % finde enstpr. str.
    m=mod(k-1,N);                 % prüfe ob Anfangswert mit N-Raster liegt
    n=find(m==0);
    if n~=0
        p(end+1)=N*length(n)/length(d);
        sym{end+1}=symbol{i};
    end
end
sum(p);                          % Ist die Summe aller Wahrscheinlichkeiten wirklich eins?
dict = huffmandict(sym,p);       % Erzeuge Huffmanbaum

% Berechne Entropie der Quelle
H=0;
for k=1:length(p)
    H=H+p(k)*log2(p(k));
end
H=H*-1;

% Berechne mittlere Codewortlänge
L=0;
for k=1:length(p)
    L=L+p(k)*length(dict{k,2});
end
L;

R=L-H                         
wert(N)=R
end
plot(wert)



