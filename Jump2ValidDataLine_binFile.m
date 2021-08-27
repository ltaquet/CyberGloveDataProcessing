function [fileID,time] = Jump2ValidDataLine_binFile(fileID)
%Jump2ValidDataLine Skips dropped CG samples until a complete sample is
%encountered when reading from a binary file instead of a device buffer
%   Some CyberGlove samples are saved to the SD card incomplete, and are 
%   invalid data sets and must be skipped. This function skips them and 
%   jumps to a valid line to continue reading in data

%Reads 1.5 lines of data to reorient the program to the start of the next
%complete data line
data_string = strjoin(string(fread(fileID,90,'*char')),'');

% Data line length including timestamp and data
TSandDataLength = 61;

%Length of just timestamp
TSlength = 14;

%Finds the length of the data string prior to the first 
[nonTS_hang] = startOfNewSample_CG(data_string);
fread(fileID,TSandDataLength-TSlength-nonTS_hang,'*char');

%Return timestamp of next complete line & file buffer starts at data
time = strjoin(string(fread(fileID,14,'*char')),'');

end

