
function skeleton = processJointNode ( xmljointnode, skeleton, parentid, idx )
%
%
% skeleton = processJointNode ( xmljointnode, skeleton, parentid, idx )

global GLOBAL_VARS_SETTINGS
  
  % the number of joints conveniently also marks the next joint to be 
  % filled with values
  currentnodeindex = skeleton.numberofjoints;
  skeleton.joints(currentnodeindex,1) = emptyJoint;
  skeleton.joints(currentnodeindex,1).parent = parentid;
  parentid=-1;
  
  if (GLOBAL_VARS_SETTINGS.VERBOSE)
    q = repmat('#',idx,1);
    fprintf('\n%d %s %s', idx, q, char(xmljointnode.getNodeName.toCharArray()));
  end % fi VERBOSE
  
  % get all children of the current node
  children = xmljointnode.getChildNodes;
  % go through children and handle them
  for c=0:children.getLength-1
    node = children.item(c);
    nodetype = node.getNodeType;
    switch nodetype
      % only handle ELEMENT_NODES
      case node.ELEMENT_NODE
        switch lower(node.getNodeName.toCharArray()')
          case 'joint'
            % increasing the number of joints before processing the next
            % joint node leads to being able to use this for constructing
            % the next joint node (it will be empty if something goes
            % wrong)
            skeleton.numberofjoints = skeleton.numberofjoints+1;
            [skeleton] = processJointNode( node, skeleton, parentid, idx+1 );
          case 'name'
            if (GLOBAL_VARS_SETTINGS.VERBOSE)
              fprintf('   name: %s ', char(node.getFirstChild.getData.toCharArray()));
            end % fi VERBOSE
            skeleton.joints(currentnodeindex,1).jointname = node.getFirstChild.getData.toCharArray()';
          case 'id'
            id = str2num(char(node.getFirstChild.getData.toCharArray())');
            if (GLOBAL_VARS_SETTINGS.VERBOSE)
              fprintf('   ID: %d', id );
            end % fi VERBOSE
            parentid=id;
            skeleton.joints(currentnodeindex,1).id = id;
          case 'position'
            position = str2num(char(node.getFirstChild.getData.toCharArray())')';
            if (GLOBAL_VARS_SETTINGS.VERBOSE)
              fprintf('   p: < ');
              fprintf('%d ', position );
              fprintf('>');
            end % fi VERBOSE
            skeleton.joints(currentnodeindex,1).position = position;
          case 'limits'
            if (GLOBAL_VARS_SETTINGS.VERBOSE)
              fprintf('   l');
            end % fi VERBOSE
            [limits, dof] = processLimitsNode( node );
            skeleton.joints(currentnodeindex,1).limits = limits;
            skeleton.joints(currentnodeindex,1).dof = dof;
          case 'basis'
            if (GLOBAL_VARS_SETTINGS.VERBOSE)
              fprintf('   b');
            end % fi VERBOSE
            [basis] = processBasisNode( node );
            skeleton.joints(currentnodeindex,1).localcoordinatesystem = basis;
          otherwise
        end % switch node name

      otherwise
    end %switch node type

  end %for
  
  
end % of function processJoint
