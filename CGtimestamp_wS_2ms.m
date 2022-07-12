function [ts] = CGtimestamp_wS_2ms(CGtimestamp, dateOfCollection)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    hour = str2double(string(CGtimestamp(1:2)));
    m = str2double(string(CGtimestamp(4:5)));
    s = str2double(string(CGtimestamp(7:8)));
    fracSecond = str2double(string(CGtimestamp(10:11)));
    sample = str2double(string(CGtimestamp(13)));
    
    
    ts.time = datetime(dateOfCollection.Year, dateOfCollection.Month, dateOfCollection.Day, hour, m, s);
    ts.fs = fracSecond*1000000/30;
    ts.fs = ts.fs + (sample+1)*1000000/90;
    
end

