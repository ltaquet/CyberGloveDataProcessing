 clear; clc;
 
 
%Set current directory as location of this script
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')

%Checks directories for patient
curr_dir = pwd;
cd ../../Patients
patients = dir();
patients = patients(3:end);
patients = struct2cell(patients);
patients = patients(1,:);
patients{end+1} = 'New Patient';
PID = listdlg('Name','Patient ID?', 'PromptString','Patient ID?','ListString',patients,...
    'SelectionMode','single',...
    'ListSize',[200 100]);
if isempty(PID)
    fprintf("Aborted\n");
    return
end
PID = patients{PID};

if PID == "New Patient"
    fprintf("Run newPatient.m to create directory for new patient\n");
    return
end

cd(PID);

cd cal
load(strcat(PID,'_cal.mat'));
cd ../'Uncalibrated Data'

filetype = strcat(PID,'_raw_','*.mat');
unprocessed_files = dir(filetype);
fprintf("There are ");
fprintf(num2str(length(unprocessed_files)));
fprintf(" file(s) of unprocessed data\n");

allTasks = input("List task names deliminated by a comma and a space (i.e task1, task2, task3): ",'s');
task_names = split(allTasks,', ');
trial_name = input("Overal Trial Name: ",'s');
mkdir(strcat(trial_name,'_raw'));

if length(task_names) ~= length(unprocessed_files)
   fprintf("Given number of task names does not equal the ");
   fprintf(num2str(length(unprocessed_files)));
   fprintf(" file(s) of unprocessed data\n");
   fprintf("CHECK THAT YOU LISTED TASKS WITH BOTH A COMMA THEN A SPACE (i.e task1, task2, task3)\n");
   cd(curr_dir)
   return 
end

 for index = 1:1:length(unprocessed_files)
     
     load(unprocessed_files(index).name); 
     movefile(unprocessed_files(index).name,strcat(trial_name,'_raw'));
     
     here = pwd;
     cd(curr_dir);
     [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,90);
     cd(here);
     
     cd ../'Calibrated Data'
     if ~exist(trial_name,'dir')
        mkdir(trial_name);
     end
     cd(trial_name);
  
     save(strcat(PID,'_',task_names{index},'.mat'), 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f');
     
     cd ../../'Uncalibrated Data'
      
 end
 
cd(curr_dir);
 
