
function skeleton = constructNamemap ( skeleton )
% constructs a name map for a read in skeleton and saves it to the skeleton
%
% the namemap is a <#joints x 3> cell array in which the
% first column contains the index of a joint,        the
% second column contains the ID of a joint,      and the
% third column contains the string name of a joint
%
% <index>    <ID>    <string name>
%
% INPUT
%   skeleton ... skeleton struct
%
% OUTPUT
%   skeleton ... skeleton struct with a namemap
%
% EXAMPLE
%

  for i=1:size(skeleton.joints,1)
    skeleton.namemap{i,1} = i;
    skeleton.namemap{i,2} = skeleton.joints(i).id;
    skeleton.namemap{i,3} = skeleton.joints(i).jointname;
    skeleton.jointnames{i,1} = skeleton.joints(i).jointname;
  end % for look through joints

end

