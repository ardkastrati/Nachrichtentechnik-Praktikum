function [ vec_up, vec_do ] = aufgabe3_1( vec )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(vec)
%     vec_up=[vec_up vec(i) vec(i) vec(i) vec(i) vec(i)]
    vec_up(5*(i-1) + 1:5*i)=vec(i);
end

% vec_do = vec_up(1:3:length(vec_up));
for i = 1:floor(length(vec_up)/3)
    vec_do(i) = vec_up(3*(i-1) + 1);
end

end

