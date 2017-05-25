% NTP - Stochastische Signale - Stationaritaet und Ergodizitaet (A1)

close all
clc

%% Realisierungen verschiedener Prozesse erzeugen

% nur einmal berechnen
if ~exist('x_all', 'var')
    
    % Anzahl der Elemente
    N = 2000;  
    
    % Gleichverteilung
    x1  = rand(N);

    % Normalverteilung   
    x2 = randn(N);  

    % zeitlich veraenderlicher Erwartungswert
    mu = cos(2*pi * 25/N * (1:N)) / 10;
    x3 = randn(N) + repmat(mu, N, 1);

    % zeitlich veraenderliche Varianz
    sigma = sin(2*pi * 25/N * (1:N));
    x4 = randn(N) .* repmat(sigma, N, 1);

    % zeitlich veraenderliche Varianz und Erwartungswert
    x5 = randn(N) .* repmat(sigma, N, 1) + repmat(mu, N, 1);

    % alle Prozesse ein cell
    x_all = {x1, x2, x3, x4, x5};

    clear mu sigma x1 x2 x3 x4 x5
end


%% Momente der Prozesse berechnen und Labels festlegen

mu_schar.name = 'Scharmittelwerte';
mu_schar.xlabel = 'Zeitindex';
mu_schar.ylabel = 'Mittelwert';
mu_schar.values = cellfun(@(x) {mean(x, 1)}, x_all);

o2_schar.name = 'Scharvarianzen';
o2_schar.xlabel = 'Zeitindex';
o2_schar.ylabel = 'Varianz';
o2_schar.values = cellfun(@(x) {var(x, 1, 1)}, x_all);

mu_time.name = 'Zeitmittelwerte';
mu_time.xlabel = 'Scharindex';
mu_time.ylabel = 'Mittelwert';
mu_time.values = cellfun(@(x) {mean(x, 2).'}, x_all);

o2_time.name = 'Zeitvarianzen';
o2_time.xlabel = 'Scharindex';
o2_time.ylabel = 'Varianz';
o2_time.values = cellfun(@(x) {var(x, 1, 2).'}, x_all);


%% Plots erstellen

% zeige alle folgenden Plots in einem Fenster
set(0,'DefaultFigureWindowStyle','docked')

for plot_var = {mu_schar, mu_time, o2_schar, o2_time}
    figure('Name', plot_var{1}.name)
    % Werte des aktuelles Moments für alle Prozesse
    values = plot_var{1}.values;  
    % berechne Min/Max für den Anzeigebereich
    v_min = min(min(cell2mat(values)));
    v_max = max(max(cell2mat(values)));
    % ein Subplot pro Prozess erzeugen
    for i = 1:length(values) 
        subplot(length(values), 1, i)
        
        plot(values{i})
        
        xlabel(plot_var{1}.xlabel); ylabel(plot_var{1}.ylabel); grid on;
        legend(sprintf('Prozess %d', i))
        axis([-inf, inf, 1.2*v_min, 1.2*v_max])
    end; clear i
   
end; clear plot_var values v_*
