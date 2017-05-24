maxlag = 200;
f_a = 30e6;

% test call
mytoda2 = tdoa(r2,r1,maxlag);
mytoda3 = tdoa(r3,r1,maxlag);
mytoda4 = tdoa(r4,r1,maxlag);
mytoda5 = tdoa(r5,r1,maxlag);

% time in seconds
t2 = mytoda2/f_a;
t3 = mytoda3/f_a;
t4 = mytoda4/f_a;
t5 = mytoda5/f_a;

% % verfication call
% [korrelation, lags] = xcorr(r1,r5,maxlag);
% [minimum, index] = max(abs(korrelation));
% toda = lags(index);