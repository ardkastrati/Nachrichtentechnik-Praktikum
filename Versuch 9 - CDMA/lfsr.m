function OutputVector = lfsr(GenPoly,State,OutLength);
%LFSR computes the output of a Linear Feedback Shift Register.
%
%   OutputVector = lfsr(GenPoly,State,OutLength)
%
%   OutputVektor : Output of the Shift Register
%   GenPoly      : Generator Polynomial given as 0/1 vector
%                  [x^1 x^2 ... x^N] or vector of
%                  exponents [1 7 19 ... N]
%   State        : Initial state as 0/1 vector (length N) or vector of
%                  exponents [1 14 21 ...] (max number : N)
%   OutLength    : Length of the Output of the Shift Register
%
%   EXAMPLE:
%               x = lfsr([0 0 1 0 0 0 1],[0 0 1 1 0 1 0],ones(1,100));
%             
%               [0 0 1 0 0 0 1] or [3 7] represent g = 1 + x^3 + x^7

MaxGenPoly = max(GenPoly);
MaxState = max(State);

if MaxGenPoly > 1
    tmp(GenPoly) = 1;
    GenPoly = tmp;
end

if (MaxState > 1) || (length(State) < MaxGenPoly) 
    tmp = zeros(1,MaxGenPoly);
    tmp(State) = 1;
    State = tmp;
end

for k = 1 : OutLength;
    % find elements for XOR and compute result x0
    x0 = mod(length(find(gfmul(State,GenPoly))),2);
    State= circshift(State',1)';
    State(1) = x0;
    OutputVector(k) = x0;
end

% $Id$
