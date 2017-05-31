clear all
close all
clc
load wikipedia.mat;  % Zu verschlüsselnder Text, Variable d


%Zuordnung Buchstaben -> Zahlen
S_alt='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ .,-:';
S_neu=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
for i=1:length(d)
    for j=1:length(S_alt)
        if d(i)==S_alt(j)
            D(i)=S_neu(j);
        end
    end
end

%Schlüssel
load key.mat; % Lade Schlüssel, Variable K

%Verschlüsseln
G=mod(D+K,34);

%Erzeuge Histogramm der Verschlüsselten Daten

[p,x]=hist(G,[0:33]);
p=p/length(G);
bar(x,p)

%Entschlüsseln
D_r=mod(G-K,34);

%Zuordnung Zahlen -> Buchstaben
S_neu='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ .,-:';
S_alt=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
for i=1:length(G)
    for j=1:length(S_alt)
        if G(i)==S_alt(j)
            g(i)=S_neu(j);
        end
    end
end

%Zuordnung Zahlen -> Buchstaben
S_neu='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ .,-:';
S_alt=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
for i=1:length(D_r)
    for j=1:length(S_alt)
        if D_r(i)==S_alt(j)
            d_r(i)=S_neu(j);
        end
    end
end

disp('Unverschlüssleter Text:')
disp(d(1:100))
disp('Verschlüsselter Text:')
disp(g(1:100))
disp('Entschlüsselter Text:')
disp(d_r(1:100))
