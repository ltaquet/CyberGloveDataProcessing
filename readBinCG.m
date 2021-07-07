clear; clc; 
%IMPROVEMENT TO DO:
% - Verify angle calculations


sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

%%%%%%%%%%%%%%%%%%%%%%%
% RETRIEVE GLOVE DATA %
%%%%%%%%%%%%%%%%%%%%%%%

% Select CG III binary sd card file from directory
% f = msgbox('Select CG III binary sd card file');
% uiwait(f);
% [file,path] = uigetfile('*', "Select CG III binary sd card file");
% filename = file;
% %Opens selected file
file = 'ongterm3';
fileID = fopen(file);
%slength = 251680;
slength = 186840;

% Skips over header info
HeaderX = fgetl(fileID);
header = fread(fileID,28,'uint8=>char*1');

% Sets loop condition 
isColon = ":";
PID = 'Leon_T';

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
              while ~isCG_timestamp(time)
                  sampleCount
                  [~,time] = Jump2ValidDataLine_binFile(fileID);
                  
                  time
                  pause(2);
                  %error('Error: Dang...');
              end
              timestamp1 = time(4:(end-6));
           
           
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
        
        backup = strcat(PID, "_raw_", string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss')),'.mat');
        
        cd ../../patients/
        cd(PID)
        cd('Uncalibrated Data');        
        save(backup, 'rawData', 'data_time');
        
   


%Closes File
fclose(fileID);