function [timestamps] = continuousCG_acq(port, PID, player,sample_rate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s = port;
curr_dir = pwd;

%filename = strcat(PID,'_',answer,'.mat');

% Enables Wifi Streaming
write(s,"1ew",'string');
write(s,"1ts",'string');

%sets CyperGlove clock to current time
curr_time = datestr(now,'HH:MM:SS');
write(s,curr_time,'string');

fprintf("Task in 3...");
pause(1);
%Starts stream before tone to get baseline data
flush(s);
write(s,"1S",'string'); tic;
fprintf("2...");
pause(1);
fprintf("1...\n");

pause(1);

%Plays Sound
play(player)

MARKorEND = "";
firstPass = true;

% Initialize Timestamp Vars
timestamps = strings(100);
num_stamps = 0;
last_mark = 0;


while MARKorEND ~= "End"
    MARKorEND = questdlg('Record Time Stamp or End Stream?', ...
        'Mark or End?', ...
        'Mark','Toss','End','Mark');
    if MARKorEND == "End"
        write(s,"!!!",'string');
    end 
    
    if MARKorEND == "Toss"
        time_stamped = datestr(now,'HH:MM:SS');
        timestamp1 = '0';
        while ~strcmp(timestamp1, time_stamped)
            if firstPass
                line = read(s,60,'char');
                fprintf('\n');
                timestamp1 = retrieve_CGtimestamp(line);
                firstPass = false;
            else
                line = read(s,61,'char');
                fprintf('\n');
                timestamp1 = retrieve_CGtimestamp(line);
            end           
        end
        
    end 
    
    if MARKorEND == "Mark"
        time_stamped = datestr(now,'HH:MM:SS');
        time_elapsed = toc;
        task_time = time_elapsed - last_mark;
        last_mark = time_elapsed;
        
        num_stamps = num_stamps + 1;
        timestamps(num_stamps) = time_stamped;
        if num_stamps == 1
           read(s,2,'char')  
        end
        
        rawData = zeros(sample_rate*floor(task_time),23,'int16'); %TEST%
        data_time = strings(sample_rate*floor(task_time));
        dataRow = zeros(1,23);

        sampleCount = 1;
        %while s.NumBytesAvailable >= 48
        timestamp1 = '0';
        while ~strcmp(timestamp1, time_stamped)
        %for i = 1:1:(sample_rate*floor(task_time))
           if firstPass
%               hang = read(s,3,'char')
              time = read(s,14,'char');
              if ~isCG_timestamp(time)
                  write(s,"!!!",'string');
                  return
              end
              timestamp1 = time(1:(end-6));
              

              firstPass = false;
           else
              time = read(s,17,'char');
              if ~isCG_timestamp(time)
                  write(s,"!!!",'string');
                  return
              end
              timestamp1 = time(4:(end-6));
           end
           
           for index = 1:1:23
                
               if index ~= 7
                %Refer to CyberGlove3.cpp for bitwise math when calculating raw
                %sensor values from binary CG sd card file
                
                sample = bitshift(read(s,1,'uint8'),8,'uint16') + read(s,1,'uint8');
               else
                   
                   sample = 0;
               end
                
                
                dataRow(1,index) = sample;
                
            end
            
            %rawData = [rawData; dataRow];
            rawData(sampleCount,:) = dataRow;
            data_time(sampleCount) = timestamp1;
            
            sampleCount = sampleCount + 1;

        end
        
        backup = strcat(PID, "_raw_", string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss')),'.mat');
        
        cd ../../patients/
        cd(PID)
        cd('Uncalibrated Data');        
        save(backup, 'rawData', 'data_time');
        cd(curr_dir);
    end

    
end

timestamps = timestamps(1:num_stamps);

record_time = toc;

end


