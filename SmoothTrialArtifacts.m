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
cd(fileparts(which('Skim_Trial_Data.m')));
curr_dir = pwd;

addpath(curr_dir)
addpath('Functions');

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];
fingers = [2 5 9 13 17];

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

%Chose specific file
file = uigetfile('*.mat');
load(file);
figure;
hold on;
tiledlayout(2,3)

for i = 1:1:length(fingers)
    nexttile;
    %plot(angles_deg_f(:,fingers(i)));
    plot(finger_norms(i,angles_deg_f));
    
   
    
    title(strcat(sensors_full(fingers(i))));
    
end



Start = input('About what frame does the artifact start?: ');
End = input('End?: ');

if isempty(Start)
    return
end

move_name = file;
[~,trial_name,~]=fileparts(pwd);
mkdir(strcat(trial_name,'_spiked'));

if ~exist(strcat(trial_name,'_spiked'),'dir')
    mkdir(strcat(trial_name,'_spiked'));
end
cd(strcat(trial_name,'_spiked'));

save(move_name, 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f', 'data_time');
cd ..
                    
for i = 1:1:23
   angles_deg_f(Start:End,i) = NaN;
   angles(Start:End,i) = NaN;
   angles_f(Start:End,i) = NaN;
   angles_deg(Start:End,i ) = NaN;
   rawData(Start:End,i ) = NaN;
   

   angles_deg_f(:,i)=inpaint_nans(angles_deg_f(:,i));
   angles(:,i) = inpaint_nans(angles(:,i));
   angles_f(:,i) = inpaint_nans(angles_f(:,i));
   angles_deg(:,i) = inpaint_nans(angles_deg(:,i));
   

    save(move_name, 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f', 'data_time');
    
end

figure;
hold on;
tiledlayout(2,3)

for i = 1:1:length(fingers)
    nexttile;
    %plot(angles_deg_f(:,fingers(i)));
    plot(finger_norms(i,angles_deg_f));
    
   
    
    title(strcat(sensors_full(fingers(i))));
    
end




