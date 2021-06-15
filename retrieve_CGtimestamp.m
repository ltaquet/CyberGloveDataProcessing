function [timestamp] = retrieve_CGtimestamp(timestamp_string)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
validTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]';



if ~numel(regexp(timestamp_string,validTS))
   fprintf('CyberGlove Error: Invalid Glove Data/Data Shift\n');
   fprintf('Assumed timestamp: ');
   fprintf(timestamp_string);
   fprintf('\n');
   timestamp = '';  
else
    [startIndex,endIndex] = regexp(timestamp_string,validTS);
    timestamp = timestamp_string(startIndex:endIndex);
end




end

