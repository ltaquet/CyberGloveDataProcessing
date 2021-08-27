 function [device,time] = Jump2ValidDataLine(device)
%Jump2ValidDataLine Skips dropped CG samples until a complete sample is
%encountered
%   Some CyberGlove samples are sent incomplete, and are invalid data sets
%   and must be skipped. This function skips them and jumps to a valid line
%   to continue reading in data

%Reads 1.5 lines of data to reorient the program to the start of the next
%complete data line
data_string = strjoin(string(read(device,90,'char')),'');

% Data line length including timestamp and data
TSandDataLength = 61;

%Length of just timestamp
TSlength = 14;

%Finds the length of the data string prior to the first 
[nonTS_hang] = startOfNewSample_CG(data_string);
read(device,TSandDataLength-TSlength-nonTS_hang,'char');

%Return timestamp of next complete line & device buffer starts at data
time = read(device,14,'char');
end

