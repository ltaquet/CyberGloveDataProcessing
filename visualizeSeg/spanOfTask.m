function [spanArray] = spanOfTasks(task)
%spanOfTask 
%   Returns the time span of a CyberGlove Calibrated Trial

curr_dir = pwd;
cd(task);
filetype = strcat('*.mat');
dirTask = dir(filetype);
spanArray = string(length(dirTask));


 for index = 1:1:length(dirTask)
     
     load(dirTask(index).name); 
     startTime = data_time(1);
     endTime = data_time(end);
     
     spanArray(index) = strcat(startTime, " to ", endTime);
     
 end

cd(curr_dir)
end

