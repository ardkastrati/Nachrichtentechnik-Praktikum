function ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 8 - Digitale Modulation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ytx = DM_tx_filter(filtorder, rolloff, nsamp, y) interpolates and filters
% with an rrc filter. 
%

delay = filtorder/(nsamp*2);    % Group delay (# of input samples)

% Create a raised cosine filter.    
rrcfilter = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

% Plot impulse response.
%figure(2); impz(rrcfilter,1);
%figure(3); freqz(rrcfilter,4);

% upsample and apply raised cosine filter.
ytx = rcosflt(y,1,nsamp,'filter',rrcfilter);
%scatterplot(y(1:5e3),1,0,'rx'); % optional

end

% $Id$
