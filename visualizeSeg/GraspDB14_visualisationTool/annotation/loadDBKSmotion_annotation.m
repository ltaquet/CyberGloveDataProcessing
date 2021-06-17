function motion_annotation = loadDBKSmotion_annotation (filename, varargin)
% motion_annotation = loadDBKSmotion_annotation (filename, verbose)
%
% Load a pre-saved .mat motion annotation file from the db-ks database. 
%
% INPUT
%   filename ... full database (db-ks) path and filename for file to load
%   verbose .... print text warnings (true) or don't (false). Default = true
%                 
% 
% OUTPUT
%   motion_annotation ... motion_annotation struct
%   If there was no annotation this function will return an empty double array.
%
% EXAMPLES
%   loadDBKSmotion([folders{3} files{3}(901).name]);
%   loadDBKSmotion('D:\PhD\native\db-ks\data\ex03\rad\12_00_ex03-1-rad-025-grasp-su04.txt');
%
%

switch nargin
  case 1
    verbose = true;
  otherwise
    verbose = varargin{1};
end

filenamesupplementMAT = '_annot.mat';
filenamesupplementTXT = '_annot.txt';

[filepath, filename, fileext] = fileparts(filename);
filenameMAT = [filepath filesep filename fileext filenamesupplementMAT];
filenameTXT = [filepath filesep filename filenamesupplementTXT];

% load the file or retun empty array
if (exist(filenameMAT, 'file') == 2)
  load ( filenameMAT, 'motion_annotation');
elseif (exist(filenameTXT, 'file') == 2)
  motion_annotation = readDBKSannotation(filenameTXT);
else
  if verbose
    display(sprintf('\nThe file\n  %s\nhas no annotation\nReturning empty array.\n', filename));
  end
  motion_annotation=[];
end



end
