
function skeleton = constructPalm ( skeleton )
  
  path = [];
  pathidx=0;
  if (isempty(skeleton.paths))
    pathidx = 1;
  else
    pathidx = length(skeleton.paths)+1;
  end
  
  
  namemap = skeleton.namemap;
  for i=1:length(namemap)
    % compare last three characters with 'mcp'
    if ( strcmp('mcp',namemap{i,3}(end-2:end)) )
      jointid = namemap{i,2};
      path = [path, jointid];
    end
  end % for
  
  skeleton.paths{pathidx,1} = path;
  
end % of function constructPalm
