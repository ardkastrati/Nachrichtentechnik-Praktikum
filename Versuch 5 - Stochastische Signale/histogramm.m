% NTP - Stochastische Signale - Das Histogramm (A2)

%% Parameter

% Anzahl der Elemente
N = 1e6;
% Anzahl der Klassen
nbins = 50;


%% Berechnung

% Gaussverteilung
x = randn(1, N);
% Historgramm
h = hist(x, linspace(-3, 3, nbins));


%% Plot

figure('Name', sprintf('Histogramm (N=%d, nbins=%d)', N, nbins));

h = bar(h / N);

set(h, 'DisplayName', sprintf('N=%d', N))
xlim([0, nbins + 1])
xlabel('Index'); ylabel('relative Häufigkeit'); grid on;
