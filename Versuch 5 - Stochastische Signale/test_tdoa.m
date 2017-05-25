clear all

% test data
s1 = randi([-3,3],10,1);
s2 = randi([-3,3],15,1);
maxlag = 14;

% test call
[mytoda,mykorrelation, mylags] = tdoa(s1,s2,maxlag);

% verfication call
[korrelation, lags] = xcorr(s1,s2,maxlag);
korrelation = round(korrelation);
[minimum, index] = max(abs(korrelation));
toda = lags(index);

% ceck
isequal(mytoda,toda) && isequal(mykorrelation,korrelation)