
function index = id2index (namemap, jointid)
%
%
% index = id2index (namemap, jointid)

  % namemap organization:
  % index - id - jointname
  
index = find([namemap{:,2}] == jointid);
  


end
