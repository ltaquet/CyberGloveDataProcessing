
function skeleton = processSkeletonNode ( xmlnode, skeleton )
%
%
% function skeleton = processSkeletonNode ( xmlnode, skeleton )

global GLOBAL_VARS_SETTINGS
  
  if (GLOBAL_VARS_SETTINGS.VERBOSE)
    fprintf('%s\n',char(xmlnode.getNodeName.toCharArray()));
  end % fi VERBOSE
  % get all children of the current node
  children = xmlnode.getChildNodes;
  % go through children and handle them
  for c=0:children.getLength-1
    node = children.item(c);
    nodetype = node.getNodeType;
    % only look into element nodes
    if ( nodetype == children.ELEMENT_NODE )
      if ( strcmp(node.getNodeName.toString,'units') )
        [skeleton] = processUnitsNode ( node, skeleton );
      elseif ( strcmp(node.getNodeName.toString,'joint') )
        %skeleton.joints = emptyJoint();
        skeleton.numberofjoints = skeleton.numberofjoints+1;
        [skeleton] = processJointNode ( node, skeleton, -1, 0 );
      end % fi units or joint
    end % fi ELEMENT_NODE
    %children.ELEMENT_NODE   % 1
    %children.ATTRIBUTE_NODE % 2
    %children.TEXT_NODE      % 3
    %children.ENTITY_NODE    % 6
    %children.COMMENT_NODE   % 8
    %children.DOCUMENT_NODE  % 9
    %children.TYPE_NODE      %20
  end % for
  
end % of function process Skeleton
