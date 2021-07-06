function [device,time] = Jump2ValidDataLine(device)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
data_string = strjoin(string(read(device,90,'*char')),'');

TSandDataLength = 61;
TSlength = 14;
[nonTS_hang] = startOfNewSample_CG(data_string);
read(device,TSandDataLength-TSlength-nonTS_hang,'*char');
time = strjoin(string(read(device,14,'*char')),'');

end

