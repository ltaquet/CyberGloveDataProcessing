
function [basis] = processBasisNode ( xmljointnode )
% Write here what this function does
% 
% [basis] = processBasisNode ( xmllimitsnode )
%

  xbasis = zeros(3,1);
  ybasis = zeros(3,1);
  zbasis = zeros(3,1);
  
  children = xmljointnode.getChildNodes;
  for c=0:children.getLength-1
    node = children.item(c);
    nodetype = node.getNodeType;
    switch nodetype
      % only handle ELEMENT_NODES
      case node.ELEMENT_NODE
        nodename = lower(node.getNodeName.toCharArray()');
         switch nodename
           case 'vecx'
             xbasis = str2num(char(node.getFirstChild.getData.toCharArray())')';
           case 'vecy'
             ybasis = str2num(char(node.getFirstChild.getData.toCharArray())')';
           case 'vecz'
             zbasis = str2num(char(node.getFirstChild.getData.toCharArray())')';
           otherwise
             fprintf('- ');
         end
         
      otherwise
    end %switch node type
  end %for

  basis = [xbasis ybasis zbasis];
  
end
