 clear; clc;
 
 
%Set current directory as location of this script
cd(fileparts(which('ProcessRawCGmat.m')));
addpath('Functions');

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

%Loads CG MATLAB Calibration file for the PID
load(strcat(PID,'_cal.mat'));
cd ../'Uncalibrated Data'

%Report the number of uncalibrated files for the PID
filetype = strcat(PID,'_raw_','*.mat');
unprocessed_files = dir(filetype);
fprintf("There are ");
fprintf(num2str(length(unprocessed_files)));
fprintf(" file(s) of unprocessed data\n");

%Asks the user for the task names for the unprocessed files and processed
%file Trial folder
allTasks = input("List task names deliminated by a comma and a space (i.e task1, task2, task3): ",'s');
task_names = split(allTasks,', ');
trial_name = input("Overal Trial Name: ",'s');
mkdir(strcat(trial_name,'_raw'));

%Catches if not enough trial names given
if length(task_names) ~= length(unprocessed_files)
   fprintf("Given number of task names does not equal the ");
   fprintf(num2str(length(unprocessed_files)));
   fprintf(" file(s) of unprocessed data\n");
   fprintf("CHECK THAT YOU LISTED TASKS WITH BOTH A COMMA THEN A SPACE (i.e task1, task2, task3)\n");
   cd(curr_dir)
   return 
end

%Processing Loop for all the unproccesed file 
 for index = 1:1:length(unprocessed_files)
     
     %Load files
     load(unprocessed_files(index).name); 
     
     %Move newly processed raw files into raw trial subdirectory 
     movefile(unprocessed_files(index).name,strcat(trial_name,'_raw'));
     
     %Saves current directory location
     here = pwd;
     
     %Return to starting directory
     cd(curr_dir);
     
     %Calibrates currently loaded unprocessed data
     [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,90);
     
     %Return to PID directory
     cd(here);
     
     %Makes a directory for PID's calibrated trial data 
     cd ../'Calibrated Data'
     if ~exist(trial_name,'dir')
        mkdir(trial_name);
     end
     cd(trial_name);
  
     %Saves newly calibrated task into the calibrated trial folder
     save(strcat(PID,'_',task_names{index},'.mat'), 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f', 'data_time');
     
     %Return to directory of other unprocessed files
     cd ../../'Uncalibrated Data'
      
 end

%Return to the startinf directory 
cd(curr_dir);
 
