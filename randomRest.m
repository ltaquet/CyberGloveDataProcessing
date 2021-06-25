function [success] = randomRest(min,max)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
rng('shuffle');
r = randi([min max],1,1);
pause(r);

success = true;

end

