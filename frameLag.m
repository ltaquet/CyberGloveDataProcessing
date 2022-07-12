function [frameLag] = frameLag(oneClock,twoClock)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


diff = seconds(oneClock.time - twoClock.time);
fsdiff = oneClock.fs - twoClock.fs;

frameLag = (((diff*1000000)+fsdiff)/1000000)/(1/90);

end

