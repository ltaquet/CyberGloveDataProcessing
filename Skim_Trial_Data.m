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

onefinger = input("Do you want to see one finger?: ",'s');


for index = 1:1:length(unprocessed_files)
    %Load a task
    if contains(unprocessed_files(index).name,onefinger,'IgnoreCase', true)
        
        load(unprocessed_files(index).name);
        
        %Creates a figure containing MCP plots for each finger
        figure;
        hold on;
        tiledlayout(2,3)
        fing_name = strrep(unprocessed_files(index).name,PID,'');
        fing_name = strrep(fing_name,'_','');
        fing_name = strrep(fing_name,'.mat','');
        fing_name = fing_name(isstrprop(fing_name,'alpha'));
        fing_arr = ["HOC", "Thumb", "Index", "Middle", "Ring", "Pinky"];
        for i = 1:1:length(fing_arr)
            if strcmpi(fing_arr(i), convertCharsToStrings(fing_name))
                fing_ind = i;
            end
        end
        
        if fing_ind == 1
            sgtitle(strcat(strrep(unprocessed_files(index).name,'_',' '),' ','Indiv score: ','N/A'));
        else
            sgtitle(strcat(strrep(unprocessed_files(index).name,'_',' '),' ','Indiv score: ',num2str(indivScore(angles,fing_ind-1))));
        end
        fingers = [2 5 9 13 17];
        finger_axis = [0 1];
        thumb_axis = [0 1];
        
        if ~isempty(angles)
            finger_axis = [floor(min(min(angles_deg_f(:,3:end))))-5 ceil(max(max(angles_deg_f(:,3:end))))+5];
            thumb_axis = [floor(min(angles_deg_f(:,2)))-5 ceil(max(angles_deg_f(:,2)))+5];
        end
        
        %Sets a uniform x and y limit for the plots in the figure for
        %comparison
        for i = 1:1:length(fingers)
            nexttile;
            %plot(angles_deg_f(:,fingers(i)));
            plot(finger_norms(i,angles_deg_f));
            
            if i  == 1
                %             ylim(thumb_axis);
            else
                ylim(finger_axis);
            end
            
            title(strcat(sensors_full(fingers(i))));
        end
        
        pause();
        close;
    end
end


cd(curr_dir);
