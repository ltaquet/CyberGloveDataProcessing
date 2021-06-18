function outputpath = convertSkeletonPath(skeleton, type)
%
% INPUT
% OUTPUT
% EXAMPLE
%


switch type
  case {'id2index'; 'id2idx'}
    outputpath = convertPathId2PathIdx;
  otherwise
    sprintf(['Unknown type: "', type, '"']);
end



%%
function idxpath = convertPathId2PathIdx
  npaths = size(skeleton.paths, 1);
  % convert path node IDs to path node indices
  idxpath = skeleton.paths;
  for k=1:npaths
    for kk = 1:length(skeleton.paths{k})
      idxpath{k}(kk) = id2index(skeleton.namemap,skeleton.paths{k}(kk));
    end
  end
end % of function convertPathId2PathIdx


end % of function convertSkeletonPath
