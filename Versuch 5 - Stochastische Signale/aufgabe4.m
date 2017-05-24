format long

clear

zufallszahlen

% Use random1-3

mw1 = mean(random1)
mw2 = mean(random2)
mw3 = mean(random3)


% Leistung gleich Varianz, da Mittelwertfrei
var1 = var(random1)
var2 = var(random2)
var3 = var(random3)

%% Zeit Plot
figure
subplot(3,1,1)
plot(x,random1)

subplot(3,1,2)
plot(x,random2)

subplot(3,1,3)
plot(x,random3)

%% Plot akf
% C = [1:length(x) length(x)-1:-1:1];
% figure
% subplot(3,1,1)
% plot(xcorr(random1)./C)
% 
% subplot(3,1,2)
% plot(xcorr(random2)./C)
% 
% subplot(3,1,3)
% plot(xcorr(random3)./C)

%% Histogramm

% Anzahl der Klassen
nbins = 10;

% Historgramm
l1 = length(random1);
h = hist(random1, linspace(-.5, .5, nbins));

figure('Name', sprintf('Histogramm (nbins=%d)', nbins));

h = bar(h / l1);

set(h, 'DisplayName', sprintf('N=%d', l1))
xlim([0, nbins + 1])
xlabel('Index'); ylabel('relative Häufigkeit'); grid on;

% Historgramm
l2 = length(random2);
h = hist(random2, linspace(-.5, .5, nbins));

figure('Name', sprintf('Histogramm (nbins=%d)', nbins));

h = bar(h / l2);

set(h, 'DisplayName', sprintf('N=%d', l2))
xlim([0, nbins + 1])
xlabel('Index'); ylabel('relative Häufigkeit'); grid on;

% Historgramm
l3 = length(random3);
h = hist(random3, linspace(-.5, .5, nbins));

figure('Name', sprintf('Histogramm (nbins=%d)', nbins));

h = bar(h / l3);

set(h, 'DisplayName', sprintf('N=%d', l3))
xlim([0, nbins + 1])
xlabel('Index'); ylabel('relative Häufigkeit'); grid on;

% Historgramm
l4 = length(random4);
h = hist(random4, linspace(-.5, .5, nbins));

figure('Name', sprintf('Histogramm (nbins=%d)', nbins));

h = bar(h / l4);

set(h, 'DisplayName', sprintf('N=%d', l4))
xlim([0, nbins + 1])
xlabel('Index'); ylabel('relative Häufigkeit'); grid on;
