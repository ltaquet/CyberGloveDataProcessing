function [isValid] = isCG_timestamp(timestamp_string)
%isCG_timestamp Checks if timestamp string is a full CG timestamp format
%   Boolean for if timestamp string is a full CG timestamp format

% 'Regular Expression' format for valid CG timestamp
validTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';

% Prints error message if invalid timestamp
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

