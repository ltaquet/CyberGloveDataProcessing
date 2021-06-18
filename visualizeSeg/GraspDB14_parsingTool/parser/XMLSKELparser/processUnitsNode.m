
function skeleton = processUnitsNode ( xmlunitsnode, skeleton )
%
%
% skeleton = processUnitsNode ( xmlunitsnode, skeleton )  

global GLOBAL_VARS_SETTINGS

  if (GLOBAL_VARS_SETTINGS.VERBOSE)
    fprintf('\n%s \n',char(xmlunitsnode.getNodeName.toCharArray()));
  end % fi VERBOSE
  % get all children of the current node
  children = xmlunitsnode.getChildNodes;
  % go through children and handle them
  for c=0:children.getLength-1
    node = children.item(c);
    nodetype = node.getNodeType;
    switch nodetype
      case children.ELEMENT_NODE          
        % set skeleton angle unit
        if (strcmp(node.getNodeName, 'angle'))
          skeleton.angleunit = node.getFirstChild.getData.toCharArray()';
        % set skeleton length unit
        elseif (strcmp(node.getNodeName, 'length'))
          skeleton.lengthunit = node.getFirstChild.getData.toCharArray()';
        end % fi angle and length unit
        if (GLOBAL_VARS_SETTINGS.VERBOSE)
          fprintf('  %s: %s\n', ...
            char(node.getNodeName.toCharArray()), ...
            char(node.getFirstChild.getData.toCharArray()) ...
           );
        end % fi VERBOSE
      otherwise
    end %switch
  end %for
  
end % of function processUnits
