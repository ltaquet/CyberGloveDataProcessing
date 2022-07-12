%% PID

clear; clc;
 
 
%Set current directory as location of this script
cd(fileparts(which('readBinCGLoop.m')));
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

%% Go to PID raw data dir

cd(PID);
cd('Raw Data');

%% Check number of files & Move Log file into Log folder
filetype = strcat(PID,'*');
unprocessed_files = dir(filetype);

if length(unprocessed_files) ~= 31
   error("More or Less than 30 Files + Log Detected!") 
end

movefile('*_Log','Logs');


%% Call bin loop rasp without PID prompt

trial_name = input("Overal Trial Name: ",'s');
mkdir(strcat(trial_name,'_bin'));
unprocessed_files = dir(filetype);
%Processing Loop for all the unproccesed file 
 for index = 1:1:length(unprocessed_files)
     
     %Load files
     
     file = unprocessed_files(index).name;
     
     
     
     %Saves current directory location
     here = pwd;
     
     %%
     %Binary Process Loop
     
     file_info=dir(file);
     the_size = file_info.bytes;
     %Header
     %data_size = the_size - 28 - length(filename);
     %No Header
     data_size = the_size;
     sample_number = floor(data_size/(131-55)) - 1;
     
     %Opens selected file
     %file = 'ongterm3';
     fileID = fopen(file);
     %slength = 251680;
     slength = sample_number;
     
     % Skips over header info (comment out if no header)
     %HeaderX = fgetl(fileID);
     %header = fread(fileID,28,'uint8=>char*1');
     
     
     
     % LOOP CONDITION EXPLANATION:
     %%%% The last time stamp in the file starts with "00 "
     %%%% BUT an actual sample time stamp starts with "00:" so if the third
     %%%% character in the time stamp is not a colon the file has ended
     
     %rawData = int16.empty;
     s.dir = dir(file);
     
     filesize = s.dir.bytes;
     rawData = zeros(ceil(filesize*0.0169), 23);
     data_time = strings(1,slength);
     %dataRow = zeros(1,22);
     
     
     % Pulls each sample from binary CG file until end of file
     tic
     sampleIndex = 1;
     fread(fileID,3,'*char')
     sampleCount = 0;
     skipped = 0;
     while ~feof(fileID)
         sampleCount = sampleCount + 1;
         %There are 22 sensors with 2 bytes of data and 12 significant bits
         
         time = fread(fileID,14,'*char');
         time = strjoin(string(time),'');
         %Runs when an invalid CG timestamp is encountered
         %Ends with valid data at the begining of device buffer
         while ~isCG_timestamp(time)
             sampleCount;
             [~,time] = Jump2ValidDataLine_binFile(fileID);
             skipped = skipped + 2;
             time;
             
             %error('Error: Dang...');
         end
         timestamp1 = time(4:(end-6));
         
         %Loops for each sensor
         for i = 1:1:23
             
             if i ~= 7
                 %Refer to CyberGlove3.cpp for bitwise math when calculating raw
                 %sensor values from binary CG sd card file
                 
                 sample = bitshift(fread(fileID,1,'uint8'),8,'uint16') + fread(fileID,1,'uint8');
             else
                 
                 sample = 0;
             end
             
            try  
                dataRow(1,i) = sample;
            catch
                sampleCount = sampleCount - 1;
                break
            end
         end
         
         %rawData = [rawData; dataRow];
         
         rawData(sampleCount,:) = dataRow;
         
            
         %[~, fullTS] = retrieve_CGtimestamp(time);
         data_time(sampleCount) = time;
         
         skip = fread(fileID,3,'*char');
         
     end
     
     rawData = rawData(1:(sampleCount-1),:);
     data_time = data_time(1:(sampleCount-1));
     
     %%
     
     %Makes a directory for PID's calibrated trial data 
     cd ../'Uncalibrated Data'
  
     %Saves newly calibrated task into the calibrated trial folder
%      save(strcat(unprocessed_files(index).name,'_',task_names{index},'.mat'), 'rawData', 'data_time');
     save(strcat(unprocessed_files(index).name,'unp','.mat'), 'rawData', 'data_time', 'skipped');

     %Return to directory of other unprocessed files
     cd ../'Raw Data'
     %Closes File
     fclose(fileID);
     %Move newly processed raw files into raw trial subdirectory 
     unprocessed_files(index).name
     movefile(unprocessed_files(index).name,strcat(trial_name,'_bin'));
     
 end

%Return to the startinf directory 
cd(curr_dir);

%% Call ProcessRawCGmat without PID prompt

clearvars -except PID trial_name curr_dir

%Set current directory as location of this script
cd(fileparts(which('ProcessRoboData.m')));
addpath('Functions');

cd(strcat("../../Patients/",PID));

cd cal

%Loads CG MATLAB Calibration file for the PID
load(strcat(PID,'_cal.mat'));
cd ../'Uncalibrated Data'

%Report the number of uncalibrated files for the PID
filetype = strcat(PID,'*.mat');
unprocessed_files = dir(filetype);
fprintf("There are ");
fprintf(num2str(length(unprocessed_files)));
fprintf(" file(s) of unprocessed data\n");

%Asks the user for the task names for the unprocessed files and processed
%file Trial folder (COMMENT OUT FOR INTRAOP)
%allTasks = input("List task names deliminated by a comma and a space (i.e task1, task2, task3): ",'s');
%task_names = split(allTasks,', ');

%Intraop Task Names

mkdir(strcat(trial_name,'_raw'));

%Catches if not enough trial names given
% if length(task_names) ~= length(unprocessed_files)
%    fprintf("Given number of task names does not equal the ");
%    fprintf(num2str(length(unprocessed_files)));
%    fprintf(" file(s) of unprocessed data\n");
%    fprintf("CHECK THAT YOU LISTED TASKS WITH BOTH A COMMA THEN A SPACE (i.e task1, task2, task3)\n");
%    cd(curr_dir)
%    return 
% end

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
     save(unprocessed_files(index).name, 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f', 'data_time','skipped');
     
     %Return to directory of other unprocessed files
     cd ../../'Uncalibrated Data'
      
 end

%Return to the startinf directory 
cd(curr_dir);
 
