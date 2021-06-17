
function index = name2index (namemap, stringname, type)
% returns the index of a string (joint name, sensor name) in a name map
%
% INPUT
%   namemap ...... list containing the mapping between indices and names
%                  for type 'joint' object is skeleton.namemap
%                  for type 'sensor' object motion.sensornames
%   stringname ... string name of the entity to be converted to an index
%                  or cell array containing string names (joints only)
%   type ......... the type represented by the name, i.e.
%                  'joint' if name is a jointname
%                  'sensor' if name is a sensor name
% OUTPUT
%   idx ... index of the name in the list
%
%
% EXAMPLE
%
% name2index(skeleton.namemap, {'th-tip';'mf-tip';'mf-tip'} );
% name2index(motion.sensornames, {'t-tmcj';'w-fe';'m-pij'}, 'sensor');
% name2index(motion.sensornames, {'t-tmcj';'w-fe';'m-pipj'}, 'sensor');
% name2index(motion.sensornames, {'t-tmcj' 'w-fe' 'm-pij'}, 'sensor');
%

if nargin == 2
  type = 'joint';
end % fi


switch type
  case 'sensor'
    
    pos = name2idx ( namemap, stringname );

    if iscell(stringname)
      index = pos;
    else
      index = find(pos);
    end
    
    
  case 'joint'
    
    pos = name2idx ( namemap(:,3), stringname );
    index = [namemap{pos,1}]';
    
  otherwise
    fprintf('unknown type: %s\n', type);
end % switch




  %% convert stringname to index into namemap
  function idx_out = name2idx ( namemap1d, stringname )
  % this function was written to avoid duplicate identical code
  
    if iscell(stringname)
      nelem = length(namemap1d);
      
      if size(stringname, 1) > size(stringname,2)
        stringname = stringname';
      end % fi check if has to be transposed
      
      idx_out = find( ... % nonzero entries in
        strcmpi( ...% the result from searching 
          repmat(stringname, nelem, 1), ...% each input joint name
          repmat(namemap1d, 1, length(stringname)) ... % in the namemap
         ) );
       idx_out = mod( idx_out-1, nelem ) + 1;
       
    else 
      idx_out = strcmpi(stringname, namemap1d);
    end % fi check if stringname is cell array
    
  end %of function name2ids

end % of functin name2index
