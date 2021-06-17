
function nodeidlist = traverseSubtree ( skeleton, nodeid, nodeidlist )
%
%
%

nodeidx = id2index ( skeleton.namemap, nodeid );

if (nargin == 2)
  nodeidlist = [];
end

%fprintf('id->idx: [%d]->[%d]\n', nodeid, nodeidx);

currentnode = skeleton.joints(nodeidx);
for k=1:length(currentnode.children)
  nodeidlist = [nodeidlist, currentnode.children(k)];
  nodeidlist = traverseSubtree ( skeleton, currentnode.children(k), nodeidlist );
end
%fprintf('leaving node %d %s\n', nodeid, currentnode.jointname);


end % of function traverseSubtree