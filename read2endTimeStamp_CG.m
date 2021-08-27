 function [TS_line] = read2endTimeStamp_CG(device)
%read2endTimeStamp_CG Summary of this function goes here
%   Detailed explanation goes here

%Initialize blank string to read in CG data until the end of a timestamp
TS_line = '';

%Read next char from device buffer
aChar = read(device,1,'char');

%Read in 1 character at a time until the end of a timestamp 
%(it ends in a S)
while ~strcmp(aChar,'S')
    TS_line = strcat(TS_line,aChar);
    aChar = read(device,1,'char');
end
TS_line = strcat(TS_line,aChar);

%'Regular Expression' for the begining of the timestamp
startTS = '(2[0-3]|[01][0-9]):';

%Finds the index for the begining of the last timestamp in the string to
%return only the timestamp of the data that is at the start of the device
%buffer
[startIndex,~] = regexp(TS_line,startTS);

%Returns the timestamp of the data that is at the start of the device
%buffer
TS_line = TS_line(startIndex:end);


end
