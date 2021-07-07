function [isValid] = isCG_timestamp(timestamp_string)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
validTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';

if ~numel(regexp(timestamp_string,validTS))
   fprintf('CyberGlove Error: Invalid Glove Data/Data Shift\n');
   fprintf('Assumed timestamp: ');
   fprintf(timestamp_string);
   fprintf('\n');
   fprintf(datestr(now,'HH:MM:SS'));
   fprintf('\n');
   isValid = false;  
   
else
    isValid = true;
end




end

