function [nonTS_hang] = startOfNewSample_CG(data_string)
%startOfNewSample_CG Finds the number of bytes of data from the last
%incomplete sample in the data string.
%   The function is meant to be used in conjunction with the known length
%   of a sample in bytes to know how many bytes must be read from the
%   device so that the device buffer is at the start of a new sample
%'Regular Expression' for a CG timestamp
validTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';

%Finds index of the end of the timestamp
[~,e] = regexp(data_string,validTS);

%Find number of bytes of cyberglove data read in the last sample
nonTS_hang = strlength(data_string) - e(end);
if nonTS_hang < 0
   data_string
   nonTS_hang
   end_ind = e(end)
   error('Neg'); 
end


end

