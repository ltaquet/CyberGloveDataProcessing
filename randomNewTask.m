function [newTaskIndex] = randomNewTask(tasks)
%randomNewTask 
%   Finds a random uncompleted task from the tasks struct
rng('shuffle');
r = randi([1 length(tasks)],1,1);
while tasks(r).completed
    r = randi([1 length(tasks)],1,1);
end

newTaskIndex = r;

end

