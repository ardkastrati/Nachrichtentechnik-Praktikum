N = 100000;
x = randn(N,1);
y = sqrt(3)*x + 2;

mean(y)
var(y)
[y_values, x_values] = hist(y,100);
breite = diff(x_values(1:2));
y_norm = y_values/(N*breite);

bar(x_values, y_norm);

