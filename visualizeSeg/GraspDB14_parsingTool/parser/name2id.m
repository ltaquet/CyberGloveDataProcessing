
function jointid = name2id (namemap, jointname)
% returns the joint id of a string (joint name) in a name map
%
% INPUT
%   namemap ..... list containing the mapping between joint ids and joint 
%                 names
%   jointname ... name of the entity to be converted to a joint id
%
% OUTPUT
%   jointid ... id of the joint represented by the name
%
% EXAMPLE 
%   name2id( skeleton.namemap, {'th-tip';'mf-tip';'mf-tip'} )
%   name2id( skeleton.namemap, 'th-tip' )
%


if iscell(jointname)
  nelements = length(namemap(:,3));
  if size(jointname, 1)>size(jointname,2)
    jointname = jointname';
  end
  pos = find (... % nonzero entries in
    strcmpi( ... % the result from searching 
      repmat(jointname, nelements, 1), ... % each input joint name
      repmat(namemap(:,3), 1, length(jointname) ) ... % in the namemap
    ) );
  pos =  mod(pos-1, nelements) +1;
else
  pos = strcmpi(jointname, namemap(:,3));
end
jointid = [namemap{pos,2}]';


end % of function name2id
