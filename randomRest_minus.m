function [preR] = randomRest_minus(min,max,minusT)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

rng('shuffle');
r = randi([min max],1,1);

preR = r;

if floor(minusT) < r
    r = r - floor(minusT);
    pause(r);
end


end

