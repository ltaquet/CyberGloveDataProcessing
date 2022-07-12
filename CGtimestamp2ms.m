function [ts] = CGtimestamp2ms(CGtimestamp, dateOfCollection)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    hour = str2double(string(CGtimestamp(1:2)));
    m = str2double(string(CGtimestamp(4:5)));
    s = str2double(string(CGtimestamp(7:8)));
    fracSecond = str2double(string(CGtimestamp(10:11)));
    
    
    
    ts.time = datetime(dateOfCollection.Year, dateOfCollection.Month, dateOfCollection.Day, hour, m, s);
    ts.fs = fracSecond*1000000/30;
    
    
end

