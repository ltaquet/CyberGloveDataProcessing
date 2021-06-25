function [tasks] = performTask(taskIndex,tasks,curr_index,uncheckBool)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if uncheckBool
    tasks(taskIndex).completed = false;
end
tasks(taskIndex).sequence = curr_index;
imshow(tasks(taskIndex).prompts);
hold on

tasks(taskIndex).completed = true;


end

