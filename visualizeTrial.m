%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% visualizeTrial 
% Created on: 6/08/2021
% Created by: Leon Taquet
% Uses: Collects CG data for vis file collection and visualization
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear

%Connects to CyberGlove
s = serialport("COM6", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;

%Initialize sound for start of streaming
[y,Fs]=audioread('buzz.wav');
player=audioplayer(y,Fs);

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

isRunning = true;

while isRunning
    cmd = input("Command: ", 's');
    
    if cmd == "stream"
        PID = input("Patient ID: ",'s');
        answer = questdlg('Which hand task is being recorded?', ...
            'Task?', ...
            'open_close','indiv','MISC','MISC');
        filename = strcat(PID,'_',answer,'.mat');
        
        % Enables Wifi Streaming
        write(s,"!!!",'string');
        write(s,"1ew",'string');

        fprintf("Streaming in 3...");
        pause(1);
        fprintf("2...");
        pause(1);
        fprintf("1...\n");
        
        pause(1);
        
        %Initiates Streaming and Plays Sound
        %flush(s)
        flush1 = read(s,s.NumBytesAvailable,'char')
        write(s,"1S",'string');
        play(player)
        
        f = msgbox('Done streaming?');
        uiwait(f);
        write(s,"!!!",'string');
      
        %read(s,6,'char');
%         binData = read(s,s.NumBytesAvailable,'char');
        
        
        rawData = int16.empty;
        dataRow = zeros(1,22);
        firstPass = true;
        
        while s.NumBytesAvailable >= 48
            %There are 22 sensors with 2 bytes of data and 12 significant bits
            if firstPass
                time = read(s,16,'char')
                firstPass = false;
            else
                time = read(s,17 ,'char')
            end
            
            for index = 1:1:22
                
                %Refer to CyberGlove3.cpp for bitwise math when calculating raw
                %sensor values from binary CG sd card file
                sample = bitshift(read(s,1,'uint8'),8,'uint16') + read(s,1,'uint8');
                
                dataRow(1,index) = sample;
                
            end
            
            rawData = [rawData; dataRow];
            
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RETRIEVE CALIBRATION DATA %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % NOTE: Uses calibration file produced by CG DCU
        
        %Select CG III calibration file from directory
        f = msgbox('Select CG III Calibration file');
        uiwait(f);
        [file2,path2] = uigetfile('*');
        
        %Opens selected file
        calID = fopen(file2);
        
        %Skips header
        Header1 = fgetl(calID);
        calNums = cell(6,2);
        index = 1;
        
        while ~feof(calID)
            fingerLabel = fgetl(calID);
            calNums(index,:) = textscan(calID, '%*f %f %f %*f');
            index = index + 1;
        end
        
        % calNums(x,1)(y) = offsets
        % calNums(x,2)(y) = gains
        % x = finger #
        % y = finger x's sensor #y
        
        offsets = cat(1,cell2mat(calNums(1,1)),cell2mat(calNums(2,1)),cell2mat(calNums(3,1)),cell2mat(calNums(4,1)),cell2mat(calNums(5,1)),cell2mat(calNums(6,1)));
        gains = cat(1,cell2mat(calNums(1,2)),cell2mat(calNums(2,2)),cell2mat(calNums(3,2)),cell2mat(calNums(4,2)),cell2mat(calNums(5,2)),cell2mat(calNums(6,2)));
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CALIBRATE RAW GLOVE DATA %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        calData = zeros(length(rawData),22);
        for i = 1:1:22
            calData(:,i) = (double(bitshift(rawData(:,i),-4)) - offsets(i))*-gains(i);
        end
        
        index_abduct = (bitshift(rawData(:,12),-4) - offsets(12)) * gains(8);
        middle_abduct = -(calData(:,16) + double(index_abduct)) * double(gains(12));
        
        calData(:,8) = double(index_abduct) + double(middle_abduct);
        calData(:,12) = double(middle_abduct);
        calData(:,16) = calData(:,16) + middle_abduct;
        calData(:,20) = calData(:,20) + calData(:,16);
        
        %TR sensor should max out at 0.5
        for i = 1:1:length(calData(:,1))
            if calData(i,1) > 0.5
                calData(i,1) = 0.5;
            end
        end
        
        %calDataL = array2table(calData,'VariableNames',sensors);
        
        angles = calData;
        
        angles_deg = rad2deg(angles);
        
        [lp1, lp2] = butter(4,(6/100*2),'low');
        angles_f = filtfilt(lp1,lp2,angles);
        angles_deg_f = filtfilt(lp1,lp2,angles_deg);
        
        %%%%%%%%%%%%%%%%%%%%%
        % SAVE MATLAB DATA %
        %%%%%%%%%%%%%%%%%%%%
        
        % Saves .mat file with the same name as the binary file
        
        save(filename, 'angles', 'sensors', 'rawData', 'angles_deg','angles_f','angles_deg_f');
        
        fclose(calID);
        
        TXTfilename = "VIS" + filename + ".txt";
        
        txtID = fopen('16_14_ex01-rad-004-grasp-su06','w');
        
        label = [2021 04 28 00 00 00.0000 1];
        labelMat = zeros(length(angles),7);
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
        txtData = [labelMat angles zeros(length(angles),1)];
        
        fprintf(txtID,'%u %2.2u %2.2u %2.2u %2.2u %08.5f %u %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f\n',transpose(txtData));
        
        fclose(txtID);
        
        
    end
    
    
    if cmd == ""
        isRunning = false;
    end
end

