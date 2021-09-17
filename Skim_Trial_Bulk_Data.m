 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skim_Trial_Data 
% Created on: 7/01/2021
% Created by: Leon Taquet
% Uses: Allows the user to see MCP plot for each finger for each task
% across a trial to roughly verify that it is valid data.
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%test pull
clc; clear

%Set current directory as location of this script
cd(fileparts(which('Skim_Trial_Bulk_Data.m')));
curr_dir = pwd;

addpath(curr_dir)
addpath('Functions');

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

isRunning = true;

%Checks directories for patient

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
cd('Calibrated Data');

% Select CG III binary sd card file from directory
f = msgbox('Select CG III trial folder');
uiwait(f);
[path] = uigetdir('*', "Select CG III binary sd card file");
%Opens selected folder
cd(path);

filetype = strcat(PID,'*.mat');
unprocessed_files = dir(filetype);
fing_arr = ["HOC", "thumb", "index", "middle", "ring", "pinky"];

% finger_ind = input('Which finger? (1-5): ');
for finger_ind = 1:1:5

figure('Name',fing_arr(finger_ind + 1));

hold on;
tiledlayout(1,6)

for index = 1:1:length(unprocessed_files)
%     if index ~= 2
        nexttile;
        %Load a task
        load(unprocessed_files(index).name);
        
        %Creates a figure containing MCP plots for each finger
        
        %fing_arr = ["HOC", "thumb", "index", "middle", "ring", "pinky"];
        
        fingers = [2 5 9 13 17];
        norms = finger_norms(finger_ind,angles_deg_f);
        
        finger_axis = [floor(min(norms))-5 ceil(max(norms))+5];
        
        
        %Sets a uniform x and y limit for the plots in the figure for
        %comparison
        
        
        plot(norms);
        
        
        ylim(finger_axis);
        
        
        title(unprocessed_files(index).name);
        
        %     if index ~= 6
        %         nexttile;
        %     end
%     end
end

end
cd(curr_dir);
