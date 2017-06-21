function OutputVector = psd(InputVector,NumberOfSegments, HoldFactor);
%PSD computes the average Power Spectral Density (PSD) of the input vector.  
%   by dividing the input vector into a certain number of segments. The
%   Zero frequency is in the middle of the resulting PSD.
%
%   OutputVector = psd(InputVector,NumberOfSegments,HoldFactor)
%
%   OutputVektor        : PSD of the input signal
%   InputVector         : Input signal, must be a (1,N) vector
%   NumberOfSegments    : Number of segments the input signal is divided
%                         into,
%   HoldFactor          : Signal is hold to get a proper spectrum
%             
%          (InputVector / NumberOfSegments) must be integer!
%
%
%   EXAMPLE:
%               Phi = psd(x,10,4);
%               

% Hold fuer Spektrum
InputVector = repmat(InputVector,HoldFactor,1);
InputVector = reshape(InputVector,1,[]);

% mittleres Leistungsdichtespektrum
InputVector = reshape(InputVector,[],NumberOfSegments);
OutputVector = abs(fft(InputVector)).^2;
OutputVector = sum(OutputVector');

% fftshift -> Mitte des Spektrums entspricht Nullfrequenz
OutputVector = fftshift(OutputVector);

end

% $Id$
