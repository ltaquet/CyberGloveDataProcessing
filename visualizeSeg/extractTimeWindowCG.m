function [startInd,endInd] = extractTimeWindowCG(data_time,startTime,endTime)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

startTime = ms2CGtimestamp(startTime);
endTime = ms2CGtimestamp(endTime);

notFound = true;
for index = 1:1:length(data_time)
    
    time = data_time(index);
    if strcmp(startTime, time) && notFound
        startInd = index;
        notFound = false;
    end

    if strcmp(endTime, time)
        endInd = index;
    end
end

