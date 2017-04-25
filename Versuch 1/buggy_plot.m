% Praktikum Nachrichtentechnik: Debugging
%
freq1 = .3
freq2 = .4;
x_axis = linespace(0, 5, 100);

f_von_x = cos(2 * pi * freq1 * x_axis)' * cos(2 * pi * freq2 * x_axis);

plot(x_axis, f_von_x);