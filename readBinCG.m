%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readBinCG
% Created on: 5/05/2021
% Created by: Leon Taquet
% Status: 
% Uses: Reads in the binary CyberGlove data file into PID specific saved 
% MATLAB workspace
% Functionality to add: - 
%                       - 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; 
%IMPROVEMENT TO DO:
% - Verify angle calculations


sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

%%%%%%%%%%%%%%%%%%%%%%%
% RETRIEVE GLOVE DATA %
%%%%%%%%%%%%%%%%%%%%%%%

%Navigate to the PID directory and ask the user to select a PID
cd(fileparts(which('readBinCG.m')));
addpath('Functions');

curr_dir = pwd;
addpath(curr_dir);
addpath('Functions');
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

%Navigate to selected PID's raw data 
cd(PID);
cd('Raw Data');

%Select CG III binary sd card file from directory
f = msgbox('Select CG III binary sd card file');
uiwait(f);
[file,path] = uigetfile('*', "Select CG III binary sd card file");
cd(path);
filename = file;

%Uses file size in bytes to determine how many samples of data are in the
%file
file_info=dir(file);
the_size = file_info.bytes;
data_size = the_size - 28 - length(filename);
sample_number = floor(data_size/(131-55)) - 1;

%Opens selected file
%file = 'ongterm3';
fileID = fopen(file);
%slength = 251680;
slength = sample_number;

% Skips over header info
HeaderX = fgetl(fileID);
header = fread(fileID,28,'uint8=>char*1');



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
for sampleCount = 1:1:slength
    
    %There are 22 sensors with 2 bytes of data and 12 significant bits
    
    time = fread(fileID,14,'*char');
    time = strjoin(string(time),'');
              %Runs when an invalid CG timestamp is encountered
              %Ends with valid data at the begining of device buffer
              while ~isCG_timestamp(time)
                  sampleCount
                  [~,time] = Jump2ValidDataLine_binFile(fileID);
                  
                  time
                  pause(2);
                  %error('Error: Dang...');
              end
              timestamp1 = time(4:(end-6));
           
           %Loops for each sensor
           for index = 1:1:23
                
               if index ~= 7
                %Refer to CyberGlove3.cpp for bitwise math when calculating raw
                %sensor values from binary CG sd card file
                
                sample = bitshift(fread(fileID,1,'uint8'),8,'uint16') + fread(fileID,1,'uint8');
               else
                   
                   sample = 0;
               end
                
                
                dataRow(1,index) = sample;
                
            end
            
            %rawData = [rawData; dataRow];
            rawData(sampleCount,:) = dataRow;
            
            %[~, fullTS] = retrieve_CGtimestamp(time);
            data_time(sampleCount) = time;
            
            skip = fread(fileID,3,'*char');

 end
 
 rawData = rawData(1:(sampleCount-1),:);
 data_time = data_time(1:(sampleCount-1));
 
 backup = strcat(PID, "_raw_", filename,'.mat');
 cd(fileparts(which('readBinCG.m')));
 cd ../../patients/
 cd(PID)
 cd('Uncalibrated Data');
 save(backup, 'rawData', 'data_time');
 
 


%Closes File
fclose(fileID);