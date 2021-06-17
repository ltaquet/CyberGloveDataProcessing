
function [limits, dof] = processLimitsNode ( xmljointnode )
% Write here what this function does
% 
% [limits,dof] = processLimitsNode ( xmllimitsnode )
%

  xminmax = zeros(1,2);
  yminmax = zeros(1,2);
  zminmax = zeros(1,2);
  
  children = xmljointnode.getChildNodes;
  for c=0:children.getLength-1
    node = children.item(c);
    nodetype = node.getNodeType;
    switch nodetype
      % only handle ELEMENT_NODES
      case node.ELEMENT_NODE
        nodename = lower(node.getNodeName.toCharArray()');
         switch nodename
           case 'rotx'
             xminmax = str2num(char(node.getFirstChild.getData.toCharArray())');
           case 'roty'
             yminmax = str2num(char(node.getFirstChild.getData.toCharArray())');
           case 'rotz'
             zminmax = str2num(char(node.getFirstChild.getData.toCharArray())');
           otherwise
             fprintf('- ');
         end
         
      otherwise
    end %switch node type
  end %for

  limits = [xminmax;yminmax;zminmax];
  dof = ((limits(:,1)-limits(:,2))' ~= [0,0,0]);
  
end
