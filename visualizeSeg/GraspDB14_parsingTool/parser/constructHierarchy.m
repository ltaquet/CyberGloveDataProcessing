%%
function skeleton = constructHierarchy ( skeleton )
  
  jointidlist = [skeleton.namemap{:,2}];

  for i=1:skeleton.numberofjoints
    
    % get parent id and convert it to extract entries from the 
    % joints' struct
    parentid = skeleton.joints(i).parent; 
    structparentid = id2index(skeleton.namemap,parentid);
    % fill child joint lists
    if ( parentid > 0 ) %&& parentid < size(skeleton.joints,1) )
      skeleton.joints(structparentid).children = [skeleton.joints(structparentid).children, jointidlist(i)];
    end % fi
    
  end % for look through joints

%     % for debugging
%     for i=1:skeleton.numberofjoints
%       fprintf('(%2d) %2d -> ', i, skeleton.joints(i).id );
%       fprintf('%2d ', skeleton.joints(i).children);
%       fprintf('\n');
%     end
  
end
