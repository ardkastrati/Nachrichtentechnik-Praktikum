function yrx = DM_rx_filter(filtorder, rolloff, nsamp, y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Digitale Modulation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% yrx = DM_rx_filter(filtorder, rolloff, y) filters
% with an rrc filter and applies down sampling. 
%

delay = filtorder/(nsamp*2);    % Group delay (# of input samples)

% Create a raised cosine filter.    
rrcfilter = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

% Plot impulse response.
%figure(2); impz(rrcfilter,1);
%figure(3); freqz(rrcfilter,4);

% apply raised cosine filter (no interpolation)
yrx = rcosflt(y,1,nsamp,'filter/Fs',rrcfilter);

yrx = downsample(yrx,nsamp); % Downsample.
yrx = yrx(2*delay+1:end-2*delay); % Account for delay.

%scatterplot(y(1:5e3),1,0,'rx'); % optional

end

% $Id$
