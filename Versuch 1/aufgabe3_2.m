function [ vec_up, vec_do ] = aufgabe3_2( vec )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
vec_up=reshape(repmat(vec,5,1),1,5*length(vec));

vec_do = vec_up(1:3:length(vec_up));
end

