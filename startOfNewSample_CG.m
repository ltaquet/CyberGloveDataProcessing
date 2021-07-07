function [nonTS_hang] = startOfNewSample_CG(data_string)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
validTS = '(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]:[0-2][0-9]:[0-2]S';

[~,e] = regexp(data_string,validTS);


nonTS_hang = strlength(data_string) - e(end);


end

