
function jointname = id2name (namemap, jointid)
% returns the joint id of a string (joint name) in a name map
%
% input
%   namemap ... list containing the mapping between joint ids and joint 
%               names
%   jointid ... ID of the joint to be converted to its (string) name
% output
%   jointname ... name of the joint represented by the ID
%

idx =  [namemap{:,2}] == jointid ;
jointname = namemap{idx,3};

end % of function name2id