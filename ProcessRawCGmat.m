 clear; clc;
 
 PID = input("Patient ID: ",'s');
 filetype = strcat(PID,'_raw_','*.mat');
 unprocessed_files = dir(filetype);
 allTasks = input("List task names deliminated by commas (i.e task1, task2, task3): ",'s');
 task_names = split(allTasks,', ');

 for index = 1:1:length(unprocessed_files)
     
     load(unprocessed_files(index).name);
 
     load('Leon_T_right_cal.mat');

     [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,90);

     load('Leon_T_right_auto_cal.mat');

     [angles_auto,angles_deg_auto,angles_f_auto,angles_deg_f_auto] = calibrateCGdata(rawData,offsets,gains,90);
 
     save(strcat(task_names{index},'.mat'), 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f',...
          'angles_auto', 'angles_deg_auto','angles_f_auto','angles_deg_f_auto');
      
 end
  
%  f = msgbox('Select CG III raw MAT file');
%  uiwait(f);
%  filetype = strcat(PID,'_raw_','*.mat');
%  [file2,path2] = uigetfile('*.mat');
%  load(file2);