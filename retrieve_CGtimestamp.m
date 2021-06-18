function [timestamp, full] = retrieve_CGtimestamp(timestamp_string)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
TS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]';
fullTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';



if ~numel(regexp(timestamp_string,TS))
   fprintf('CyberGlove Error: Invalid Glove Data/Data Shift\n');
   fprintf('Assumed timestamp: ');
   fprintf(timestamp_string);
   fprintf('\n');
   timestamp = '';  
   full = '';
else
    [startIndex,endIndex] = regexp(timestamp_string,TS);
    timestamp = timestamp_string(startIndex:endIndex);
    [startIndex,endIndex] = regexp(timestamp_string,fullTS);
    full = timestamp_string(startIndex:endIndex);
end




end

