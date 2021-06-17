
function id = index2id (namemap, index)
%
%
% id = index2id (namemap, index)

  % namemap organization:
  % structid - jointid - jointname
  id = namemap{index,2};

end
