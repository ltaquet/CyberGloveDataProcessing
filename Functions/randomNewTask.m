function [newTaskIndex] = randomNewTask(tasks)
%randomNewTask Finds an index of a random uncompleted task from the tasks struct
%   Finds an index of a random uncompleted task from the tasks struct

%Initializes the randi function for random number generation
rng('shuffle');

%Randomly chooses an index between 1 and the number of tasks
r = randi([1 length(tasks)],1,1);

%If the random task is completed, a new index is generated until an index
%for an incomplete task is found
while tasks(r).completed
    r = randi([1 length(tasks)],1,1);
end

%Returns random index of incomplete task
newTaskIndex = r;

end

