% Buchstabensalat
close all
clear all
clc
load 'text.mat'
% Erstelle Histogramm...
% Zuordnung von Buchstaben zu Zahlen
text_neu=['@'];
S_alt='ABCDEFGHIJKLMNOPQRSTUVWXYZ .,?!;-';
S_neu=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
for k=1:length(text)
    for l=1:length(S_alt)
        if text(k)==S_alt(l)
            B(k)=S_neu(l);
        end
    end
end
[p,x]=hist(B,[1:33]);

p=p/length(B);
bar(x,p)
set(gca,'XTick',[1:33])
set(gca,'XTickLabel',{'A';'B';'C';'D';'E';'F';'G';'H';'I';'J';'K';'L';'M';'N';'O';'P';'Q';'R';'S';'T';'U';'V';'W';'X';'Y';'Z';' ';'.';',';'?';'!';';';'-'})
p_alt=p;
% Entschlüsselung

S_alt=''; % Lösungsschlüssel hier eintragen
S_neu='ABCDEFGHIJKLMNOPQRSTUVWXYZ .,?!;-';
for k=1:length(text)
    for l=1:length(S_alt)
        if text(k)==S_alt(l)
            C(k)=S_neu(l);
        end
    end
end

S_alt='ABCDEFGHIJKLMNOPQRSTUVWXYZ .,?!;-';
S_neu=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
for k=1:length(C)
    for l=1:length(S_alt)
        if C(k)==S_alt(l)
            B(k)=S_neu(l);
        end
    end
end

disp(C)
