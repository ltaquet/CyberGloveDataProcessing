%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORT CALIBRATION DATA INTO MATLAB %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NOTE: Uses calibration file produced by CyberGlove III DCU

%Keeps track of starting directory which is assumed to be 
%Intraoperative-CyberGlove
curr_dir = pwd;
%Moves to directory containing new CG DCU calibrations
cd ../../'New Calibrations'

%Select CG III calibration file from directory
f = msgbox('Select CG III Calibration file');
uiwait(f);
[file2,path2] = uigetfile('*.cal');

%Builds standardized MAT filename for a cal file
%CG DCU Cal file names assumed to be PID(R/L).cal
if file2(end-3) == "."
    matCalname = file2(1:end-4);
end
matCalname = strcat(matCalname,'_cal');

%Opens selected file
calID = fopen(file2);

%Skips header
Header1 = fgetl(calID);
calNums = cell(6,2);
index = 1;

%Reads in offsets and gains from CG DCU cal file
while ~feof(calID)
    fingerLabel = fgetl(calID);
    calNums(index,:) = textscan(calID, '%*f %f %f %*f');
    index = index + 1;
end

%Loads all offsets and gains into a matrix from a cell
offsets = cat(1,cell2mat(calNums(1,1)),cell2mat(calNums(2,1)),cell2mat(calNums(3,1)),cell2mat(calNums(4,1)),cell2mat(calNums(5,1)),cell2mat(calNums(6,1)));
gains = cat(1,cell2mat(calNums(1,2)),cell2mat(calNums(2,2)),cell2mat(calNums(3,2)),cell2mat(calNums(4,2)),cell2mat(calNums(5,2)),cell2mat(calNums(6,2)));

%Jumps back to starting directory
cd(curr_dir)

%Requests PID 
cd ../../Patients
patients = dir();
patients = patients(3:end);
patients = struct2cell(patients);
patients = patients(1,:);
patients{end+1} = 'New Patient';
PID = listdlg('Name','Patient ID?', 'PromptString','Patient ID?','ListString',patients,...
    'SelectionMode','single',...
    'ListSize',[200 100]);
cd(curr_dir);
if isempty(PID)
    fprintf("Aborted\n");
    return
end
PID = patients{PID};

if PID == "New Patient"
    fprintf("Run newPatient.m to create directory for new patient\n");
    return
end

%Navigates to PID's patient folder to save CG MAT cal file
%in its calibration directory for use later
cd(curr_dir)
cd ../../Patients
cd(PID)
cd('cal')

% Saves CG MAT cal file 
save(matCalname, 'offsets','gains');
cd(curr_dir)
