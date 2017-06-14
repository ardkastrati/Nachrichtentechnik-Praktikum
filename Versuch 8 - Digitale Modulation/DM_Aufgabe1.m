% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Nachrichtentechnisches Praktikum - Aufgabe 9 - Digitale Modulation
%
%   Aufgabe 1: Spektra verschiedener Modulationsarten
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all;
%close all;

%% Parameters
% modulation parameters
M = 16;         % Size of signal constellation
k = log2(M);   % Number of bits per symbol
n = 6e4;       % Number of bits to process

% tx filter parameters
nsamp = 4;      % Oversampling rate
rolloff = 0;
filtorder = 40;

%% Signal Source
% Create a binary data stream as a column vector.
x = randi([0 1], n, 1);   % Random binary data stream
% Bit-to-Symbol Mapping
y = bits_to_symbols(x, M);

%% Transmit Filter
% tx filter
ytx = DM_tx_filter(filtorder, rolloff, nsamp, y);

%% Spectrum
%figure;
periodogram(ytx);
