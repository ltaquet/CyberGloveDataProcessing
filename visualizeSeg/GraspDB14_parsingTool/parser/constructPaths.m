
function [skeleton, currentpath] = constructPaths (skeleton, currentnodeid, currentpath)
%
% Construct paths to go along for drawing (sequence of joint IDs) and save
% them in the skeleton in the field 'paths'.
%
% INPUT
%   skeleton ........ skeleton structure
%   currentnodeid ... node to be currently handled
%   currentpath ..... path up to now
%
% OUTPUT
%   skeleton ...... updated skeleton structure
%   currentpath ... updated path
%
% EXAMPLE
%   % construct the paths
%   skeleton = constructPaths ( skeleton, 'root', 1 ); 
%
%   % call in the recursion
%   [skel, cp] = constructPaths( skel, skel.joints(nodeidx).children(i),cp);
%
  
if isstr(currentnodeid)
  temp = name2id(skeleton.namemap, currentnodeid);
  currentnodeid = temp;
end

  % initialize paths if there are none
  if ( isempty( skeleton.paths ) )
    path = [];
  else
    path = skeleton.paths{currentpath,1};
  end % fi
  % and append current node to empty or already existant path
  skeleton.paths{currentpath,1} = [path, currentnodeid];
  

  
  % get idx into joint struct array
  currentnodeidx = id2index(skeleton.namemap,currentnodeid);
  nchildren = length(skeleton.joints(currentnodeidx).children);
  
  % joint has no children and current path not empty => begin a new path
  if ( nchildren == 0 )
    if ( size(skeleton.paths,1) == currentpath )
      currentpath = currentpath+1;
    end
    return;
  end

    
      
  % reset number of children
  % get idx into joint struct array
  currentnodeidx = id2index(skeleton.namemap,currentnodeid);
  nchildren = length(skeleton.joints(currentnodeidx).children);
  
  for i=1:nchildren
    
    % every joint with >1 children needs its own path (or there will be
    % piecewise duplicate paths)
    if ( i>1 )
    
      % check if path is not empty 
      % if path is not empty begin a new path
      if (size(skeleton.paths,1) == currentpath)
        currentpath = currentpath+1;
      end % fi path not empty
      
      skeleton.paths{currentpath,1}(1) = currentnodeid;
    end % fi >1 child
    
    currentnodeidx = id2index(skeleton.namemap, currentnodeid);
    [skeleton, currentpath] = constructPaths( skeleton, skeleton.joints(currentnodeidx).children(i), currentpath);

  end % for go through children
  
end
