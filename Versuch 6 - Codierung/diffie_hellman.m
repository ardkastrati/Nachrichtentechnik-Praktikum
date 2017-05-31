
clear all
close all
clc
p_var=[3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199];
g_var=[2 2 3 2 2 3 2 5 2 3 2 6 3 5 2 2 2 2 7 5 3 2 3 5 2 5 2 6 3 3 2 3 2 2 6 5 2 5 2 2 2 19 5 2 3];
for k=1:30;%length(p_var)          % Schleife über alle Primzahlen bis 200
    for m=1:100                % 20 Zeitmessungen pro Primzahl
        p=p_var(k);
        g=g_var(k);
        %a=randint(1,1,p-2); % randint is deprecated
        %b=randint(1,1,p-2); % randint is deprecated
        a=randi([0 p-3],1,1); %Zufallszahl TN A
        b=randi([0 p-3],1,1); %Zufallszahl TN B
        
        %Berechne Exponent A=g^a mod p und B
        A=exponent(p,g,a);
        B=exponent(p,g,b);
        
        %Berechne Schlüssel
        K1=exponent(p,A,b);
        K2=exponent(p,B,a);
        
        %Angriff..
        %versuche a durch ausprobieren herauszufinden
        tic;
        i=0;
        while exponent(p,g,i) ~=A,
            i=i+1;
        end
        time_temp(m)=toc;
    end
    time(k)=mean(time_temp);
end
figure
plot(time)

    
    
