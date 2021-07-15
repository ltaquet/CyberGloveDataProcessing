function [TS_line] = read2endTimeStamp_CG(device)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
TS_line = '';
aChar = read(device,1,'char');
while ~strcmp(aChar,'S')
    TS_line = strcat(TS_line,aChar);
    aChar = read(device,1,'char');
end
TS_line = strcat(TS_line,aChar);

startTS = '(2[0-3]|[01][0-9]):';

[startIndex,~] = regexp(TS_line,startTS);
TS_line = TS_line(startIndex:end);


end
