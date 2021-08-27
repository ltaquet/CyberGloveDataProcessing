function [tasks] = performTask(taskIndex,tasks,curr_index,uncheckBool)
%performTask PHASED OUT
%   PHASED OUT
if uncheckBool
    tasks(taskIndex).completed = false;
end
tasks(taskIndex).sequence = curr_index;
imshow(tasks(taskIndex).prompts);
hold on

tasks(taskIndex).completed = true;


end

