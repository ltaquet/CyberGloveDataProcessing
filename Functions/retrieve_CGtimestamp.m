function [timestamp, full] = retrieve_CGtimestamp(timestamp_string)
%retrieve_CGtimestamp Takes in a string containing a cyberglove timestamp
%and returns the just the timestamp excluding sample number and the whole
%timestamp
%   Uses regular expressions to pull the CyberGlove timestamp from a string

%Regular expression for the timestamp w/o sample # 
TS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]';
%w/ sample #
fullTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';


%Checks if the string contains a valid CG timestamp at all
if ~numel(regexp(timestamp_string,TS))
   fprintf('CyberGlove Error: Invalid Glove Data/Data Shift\n');
   fprintf('Assumed timestamp: ');
   fprintf(timestamp_string);
   fprintf('\n');
   timestamp = '';  
   full = '';
else
    %Finds the start and end index for the timestamp substring
    [startIndex,endIndex] = regexp(timestamp_string,TS);
    timestamp = timestamp_string(startIndex:endIndex);
    [startIndex,endIndex] = regexp(timestamp_string,fullTS);
    full = timestamp_string(startIndex:endIndex);
end




end

