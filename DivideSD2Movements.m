
%%
%test pull
clc; clear

%Set current directory as location of this script
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')
addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

isRunning = true;

%%
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
cd('Calibrated Data');

%%

% Select CG III binary sd card file from directory
f = msgbox('Select CG III trial folder');
uiwait(f);
[path] = uigetdir('*', "Select CG III binary sd card file");
%Opens selected folder
cd(path);

filetype = strcat(PID,'*.mat');
unprocessed_files = dir(filetype);
fing_arr = {'HOC'; 'thumb'; 'index'; 'middle'; 'ring'; 'pinky'};

%%

%Makes a directory for PID's calibrated trial data 
     [~,trial_name,~] = fileparts(pwd);
     cd ..
     seg_trial_name = strcat(trial_name,'_movSeg');
     if ~exist(seg_trial_name,'dir')
        mkdir(seg_trial_name);
     end
     cd(path);
     %cd(seg_trial_name);

%%

HOCFile    = input('HOC file number (1-6): ');
thumbFile  = input('Thumb file number (1-6): ');
indexFile  = input('Index file number (1-6): ');
middleFile = input('Middle file number (1-6): ');
ringFile   = input('Ring file number (1-6): ');
pinkyFile  = input('Pinky file number (1-6): ');

fileNumArr = {HOCFile; thumbFile ;indexFile ;middleFile; ringFile; pinkyFile};  
fingIndArr = {3; 1 ;2 ;3; 4; 5}; 

fingFileStruct.fing = fing_arr;
fingFileStruct.file = fileNumArr;
fingFileStruct.ind = fingIndArr;
fingFileTable = struct2table(fingFileStruct);
fingFileTable = sortrows(fingFileTable,'file');
fingFileStruct = table2struct(fingFileTable);

%%
for i = 1:1:length(unprocessed_files)
    
    load(unprocessed_files(i).name);
    finger_ind = fingFileStruct(i).ind;
    
    anglesW = angles;
    angles_degW = angles_deg;
    angles_deg_fW = angles_deg_f;
    angles_fW = angles_f;
    data_timeW = data_time;
    rawDataW = rawData;
    
    norms = finger_norms(finger_ind,angles_deg_f);
    x = 1:1:length(norms);
    TF = islocalmax(norms,'MinSeparation',90*5);
    gfifty = norms > 50;
    P = TF&gfifty;
    indPeak = find(P);
    B = false(length(P),1);
    for j = 1:1:length(indPeak)
        if indPeak(j) > 600
            B(indPeak(j)-600) = 1;
        end
    end
    
    breakpts = find(B);
    mov_index = 1;
    for j = 2:1:length(breakpts)
        
        if j + 1 > length(breakpts)
           bpe = length(norms) - 1; 
        else
            bpe = breakpts(j + 1);
        end
        angles       = anglesW(breakpts(j):bpe, :);
        angles_deg   = angles_degW(breakpts(j):bpe, :);
        angles_deg_f = angles_deg_fW(breakpts(j):bpe, :);
        angles_f     = angles_fW(breakpts(j):bpe, :);
        data_time    = data_timeW(breakpts(j):bpe);
        rawData      = rawDataW(breakpts(j):bpe, :);
        
        cd ..
        cd(seg_trial_name);
        save(strcat(PID,'_',fingFileStruct(i).fing,int2str(mov_index),'.mat'), 'angles', 'rawData', 'angles_deg','angles_f','angles_deg_f', 'data_time');
        cd ..
        cd(trial_name);
        mov_index = mov_index + 1;
    end
    
end

%%