function [dirIndex] = choseTaskBasedOnTime(TaskDir)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
curr_dir = pwd;

timeArray = spanOfTask(TaskDir);
cd(TaskDir);


nameORtime = questdlg('Select Task based on Name or Time?', ...
        'Name or Time?' ,'Name','Time','Time');
switch nameORtime
    case 'Name'
        taskArray = dir('*.mat');
        taskArray = struct2cell(taskArray);
        taskArray = taskArray(1,:);
        dirIndex = listdlg('Name','Task?', 'PromptString','Task?','ListString',taskArray,...
            'SelectionMode','single',...
            'ListSize',[200 100]);

    case 'Time'
        dirIndex = listdlg('Name','Time Window?', 'PromptString','Time Window?','ListString',timeArray,...
            'SelectionMode','single',...
            'ListSize',[200 100]);
end
        
cd(curr_dir)

end

