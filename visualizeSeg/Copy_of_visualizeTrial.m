%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% visualizeTrial 
% Created on: 6/08/2021
% Created by: Leon Taquet
% Uses: Collects CG data for vis file collection and visualization
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear

cd(fileparts(which('Copy_of_visualizeTrial.m')))
curr_dir = pwd;
addpath(curr_dir);
addpath('..');
addpath('../Functions');

%Choose Patient
cd ../../../Patients
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


cd(PID)
cd 'Calibrated Data'

%Ask for trial
ft = msgbox('Select CG III Trial Folder');
uiwait(ft);
trialPath = uigetdir();

cd(trialPath);



% %Loads angles and crop to wanted window
% f = msgbox('Select CG III Trial File');
% uiwait(f);
% [file2,path2] = uigetfile('*.mat');
% load(file2)
% 
%Ask for time window


trialDir = dir('*.mat');
[taskIndex] = choseTaskBasedOnTime(trialPath);

load(trialDir(taskIndex).name);

fprintf("This task was from ");
fprintf(data_time(1));
fprintf(" until ");
fprintf(data_time(end));
fprintf(".\n");


startTime = input("Start time of movement (HH:MM:SS.MS): ",'s');
endTime = input("End time of movement (HH:MM:SS.MS): ",'s');

if isempty(startTime) 
    return
end



cd(curr_dir)

if ~strcmp(startTime , 'all')

    [startInd,endInd] = extractTimeWindowCG(data_time,startTime,endTime);

    startInd = startInd + 90;
    endInd = endInd + 90;

    if startInd >= length(angles) || endInd >= length(angles)
        fprintf("Out of bounds");
        return
    end

    angles = angles(startInd:endInd,:);

end

cd(curr_dir);
cd('data');
delete '16_14_ex01-rad-004-grasp-su06'
delete '16_14_ex01-rad-004-grasp-su06.mat'
delete '16_14_ex01-rad-004-grasp-su06_w_traj.mat'

txtID = fopen('16_14_ex01-rad-004-grasp-su06','w');

label = [2021 04 28 00 00 00.0000 1];
%labelMat = zeros(length(angles),7);
labelMat(1,:) = label;
labelIndex = 1;

while length(labelMat) ~= length(angles)
    labelNew = [labelMat(end,1) labelMat(end,2) labelMat(end,3) labelMat(end,4) labelMat(end,5) labelMat(end,6)+0.01666 labelMat(end,7)];
    if labelNew(6) >= 60
        labelNew(5) = labelNew(5) + 1;
        labelNew(6) = labelNew(6) - 60;
    end
    if labelNew(5) >= 60
        labelNew(4) = labelNew(4) + 1;
        labelNew(5) = labelNew(5) - 60;
    end
    labelMat(labelIndex,:) = labelNew;
    labelIndex = labelIndex + 1;
end



% Adds zeros for wrist abduction/wrist yaw
txtData = [labelMat angles];

fprintf(txtID,'%u %2.2u %2.2u %2.2u %2.2u %08.5f %u %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f\n',transpose(txtData));

fclose(txtID);

cd(curr_dir);

script_exampleusage_visualisationTool;
