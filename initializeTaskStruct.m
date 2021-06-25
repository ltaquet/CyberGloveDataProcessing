function [tasks] = initializeTaskStruct(task_names,task_prompts,task_photos)
%initializeTaskStruct 
%   Initializes a task struct for task based looping

if length(task_names) ~= length(task_prompts)
    error("Different number of task names and task prompt images");
end 


for i = 1:1:length(task_names)
    tasks(i).names = task_names(i);
    tasks(i).prompts = task_prompts(i);
    tasks(i).photos = task_photos(i);
    tasks(i).completed = false;
    tasks(i).timestamps = strings(20);
end

end

