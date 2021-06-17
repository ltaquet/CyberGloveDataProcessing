
function skeleton = readSkeleton ( skelfile, option )
%
% Read in a skeleton file. At this moment, only .xmlskel-files are
% supported.
%
% INPUT
%   skelfile ... string name and path of the file to load (.xmlskel-file)
%   option ..... 'fix' in order to fix local coordinate systems
%                'nofix' in order to keep the local coordinate system as it is
%
% OUTPUT
%   skeleton ... skeleton struct
%
% EXAMPLE
%   skel = readSkeleton ( strcat(GLOBAL_VARS_SETTINGS.path_skel, 'default.xmlskel') );
%

if nargin==1
  option = 'fix';
end

global GLOBAL_VARS_SETTINGS;

GLOBAL_VARS_SETTINGS.VERBOSE = false;

[~, ~, filetype] = fileparts(skelfile);
filetype = filetype(2:end);
if (strcmpi ( filetype, 'XMLSKEL' ) )
  if (strfind ( skelfile, 'leap-saved' ))
    skeleton = readXMLSKELleap ( skelfile, option );
  elseif (strfind ( skelfile, 'leap.' ))
    skeleton = readXMLSKELleap ( skelfile, option );
  else
    skeleton = readXMLSKEL ( skelfile, option );
  end
else 
  error ( ['Unknown file type: ' , filetype] );
end % fi check file extension


end % of function readSkeleton