
% LZW Codierung

clear all
clc

b='abbababbabba'; 

% Initialisiere Mustertabelle für alle Zeichen
dict_sym={['a'],['b'],['c']};

w=[];
k=1;
cnt=1;
c=[];

while k<=length(b)
    % Prüfe ob Teil der Tabelle
    treffer=0;
    Z=b(k);
    for l=1:length(dict_sym)  % Finde im Wörterbuch bekannten Zeichenfolge
        if length([w,Z])==length(dict_sym{l})
            if [w,Z]==dict_sym{l} 
                w=[w,Z];
                l=length(dict_sym);
                treffer=1;
            end
        end
    end
    if treffer==0  % Es wurde [w,Z] im Wörterbuch gefunden
        dict_sym{end+1}=[w,Z];
        %suche nun das Muster Muster in Datenbank
        for m=1:length(dict_sym)
            if length(w)==length(dict_sym{m})
                if w==dict_sym{m}
                    c(end+1)=m;
                end
            end
        end
        w=Z;
    end
    k=k+1;
    
end
if length(w)~=0
    for m=1:length(dict_sym)
        if length(w)==length(dict_sym{m})
            if w==dict_sym{m}
                c(end+1)=m;
            end
        end
    end        
end

% Decodierer

dict_sym_rec={['a'],['b'],['c']};

v=dict_sym_rec{c(1)};
r=v;
l=2;
while l<=length(c)
    if c(l)<=length(dict_sym_rec)
        w=dict_sym_rec{c(l)};
    else c(l) == length(dict_sym_rec)+1;
          w = [v,v(1)];
    end
    r=[r,w];
    dict_sym_rec{end+1}=[v,w(1)];
    v = w;
    l=l+1;
end











