% NTP - Stochastische Signale - Erzeugung von Zufallszahlen (A4)

close all;
clear;
clc

%% Parameter
show_akf = true;
activate_shift_register = true;


%% Zufallszahlen

% Zeitbasis
x = 0 : 0.3 : 12*pi;

% Zufallsgeneratoren in Matlab
sd = rand();
rng(sd, 'v5uniform');  % ehemals 'state'
random1 = rand(1, length(x)) - 0.5;

sd = rand();
rng(sd, 'v4');  % ehemals 'seed'
random2 = rand(1, length(x)) - 0.5;

sd = rand();
rng(sd, 'twister');
random3 = rand(1, length(x)) - 0.5;


%% AKF

C = [1:length(x) length(x)-1:-1:1];
if show_akf
    % Normierung

    % AKF der Pseudozufallsfolgen
    AKF1 = xcorr(random1) ./ C;
    AKF2 = xcorr(random2) ./ C;
    AKF3 = xcorr(random3) ./ C;

    % Bilder
    figure('Name','AKF Zufallsgenerator 1')
    plot(AKF1,'b-.');
    xlabel('Index'); ylabel('AKF'); grid on;
    legend('AKF Z1');
    
    figure('Name','AKF Zufallsgenerator 2')
    plot(AKF2,'b-.');
    xlabel('Index'); ylabel('AKF'); grid on;
    legend('AKF Z2');
    
    figure('Name','AKF Zufallsgenerator 3')
    plot(AKF3,'b-.');
    xlabel('Index'); ylabel('AKF'); grid on;
    legend('AKF Z3');
end


%% Schiebregister-basierender Zufallsgenerator

if activate_shift_register
    % Anfangszustand des Schieberegisters
    lfsr_init_dec = 119;

    % Rueckkoppungspolynom
    lfsr.feedback = 78;

    % Binaere Darstellung
    SchiebeRegister_bin = dec2bin(lfsr_init_dec);
    RueckkopplungsPolynom_bin = dec2bin(lfsr.feedback);

    % Speicher vorbelegen
    SchiebeRegister = zeros(1, length(SchiebeRegister_bin));
    RueckkopplungsPolynom = zeros(1, length(SchiebeRegister_bin));
    
    for i = 1:length(SchiebeRegister_bin)
        if SchiebeRegister_bin(i) == '0'
            SchiebeRegister(i) = 0;
        else
            SchiebeRegister(i) = 1;
        end;
        if RueckkopplungsPolynom_bin(i) == '0'
            RueckkopplungsPolynom(i) = 0;
        else
            RueckkopplungsPolynom(i) = 1;
        end;
    end;

    % Speicher vorbelegen
    BinString = repmat('0', 1, 7*length(x));
    random4 = zeros(1, length(x));
    
    for i = 1:7*length(x)
        Rueckkopplung = mod(sum(SchiebeRegister.*RueckkopplungsPolynom),2);
        SchiebeRegister = [Rueckkopplung SchiebeRegister(:,1:end-1)];
        BinString(i) = num2str(Rueckkopplung);
    end;
    for i = 1:length(x)
        random4(i) = bin2dec(BinString(i*7-6:i*7))/128;
    end;

    % AKF der Pseudozufallsfolge
    AKF4 = xcorr(random4) ./ C;

    % Bild
    figure('Name','AKF Zufallsgenerator 4')
    plot(AKF4,'b-.');
    xlabel('Index'); ylabel('AKF'); grid on;
    legend('AKF Z4');
end
