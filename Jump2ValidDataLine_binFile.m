function [fileID,time] = Jump2ValidDataLine_binFile(fileID)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
data_string = strjoin(string(fread(fileID,90,'*char')),'');

TSandDataLength = 61;
TSlength = 14;
[nonTS_hang] = startOfNewSample_CG(data_string);
fread(fileID,TSandDataLength-TSlength-nonTS_hang,'*char');
time = strjoin(string(fread(fileID,14,'*char')),'');

end

