function [firstPass] = CG_acq_com(cmd ,port, PID, player,sample_rate, firstPass, timestamps, num_stamps, last_mark)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s = port;
curr_dir = pwd;

%filename = strcat(PID,'_',answer,'.mat');

switch cmd
    
    case 'Start'
        % Enables Wifi Streaming
        write(s,"1m",'string');
        write(s,3,'uint8');
        write(s,"1es",'string');
        write(s,"1du",'string');
        write(s,"1ew",'string');
        write(s,"1w",'string');
        write(s,1,'uint8');
        write(s,"1s",'string');
        write(s,1,'uint8');
        write(s,"1A",'string');   
        binFile = strcat(PID, "_", string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss')));
        write(s,binFile,'string'); 
        pause(1)
        numBytes = s.NumBytesAvailable;
        write(s,1,'uint8');
        pause(3);
        write(s,1,'uint8');
        pause(1);
        

        write(s,"1ts",'string');

        %sets CyperGlove clock to current time
        curr_time = datestr(now,'HH:MM:SS');
        write(s,curr_time,'string');
        
        fprintf(datestr(now,'HH:MM:SS:FFF'));
        fprintf('\n');

        % Initialize Timestamp Vars
        timestamps = strings(100);
        num_stamps = 0;
        last_mark = 0;
        pause(1);
        flush(s);
        pause(1);
        
        fprintf(datestr(now,'HH:MM:SS:FFF'));
        fprintf('\n');
        
        write(s,"1S",'string'); tic;
        pause(1)
        firstPass = true;
       
        
    case 'Mark'
          time_stamped = datestr(now,'HH:MM:SS');
        time_elapsed = toc;
        task_time = time_elapsed - last_mark;
        last_mark = time_elapsed;
        
        num_stamps = num_stamps + 1;
        timestamps(num_stamps) = time_stamped;
        if firstPass
           read(s,2,'char');  
        end
        
        rawData = zeros(sample_rate*floor(task_time),23,'int16'); %TEST%
        data_time = strings(sample_rate*floor(task_time));
        dataRow = zeros(1,23);

        sampleCount = 1;
        %while s.NumBytesAvailable >= 48
        timestamp1 = '0';
        while ~strcmp(timestamp1, time_stamped) && (s.NumBytesAvailable > 61)
        %for i = 1:1:(sample_rate*floor(task_time))
           if firstPass
%               hang = read(s,3,'char')
              time = read(s,14,'char');
              while ~isCG_timestamp(time)
                  [~,time] = Jump2ValidDataLine(s);
                  time
%                  write(s,"!!!",'string');
%                   fprintf(datestr(now,'HH:MM:SS'));
%                   fprintf('\n');
%                   read(s,s.NumBytesAvailable,'char');
%                   error('Error: Dang...');
%                   %return
              end
              timestamp1 = time(1:(end-6));
              

              firstPass = false;
           else
              time = read(s,17,'char');
              while ~isCG_timestamp(time)
                  [~,time] = Jump2ValidDataLine(s);
                  time
%                   fprintf(datestr(now,'HH:MM:SS'));
%                   fprintf('\n');
%                   write(s,"!!!",'string');
%                   read(s,s.NumBytesAvailable,'char')
%                   pause(5);
%                   error('Error: Dang...');
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
            
            [~, fullTS] = retrieve_CGtimestamp(time);
            data_time(sampleCount) = fullTS;
            
            sampleCount = sampleCount + 1;

        end
        
        rawData = rawData(1:(sampleCount-1),:);
        data_time = data_time(1:(sampleCount-1));
        
        backup = strcat(PID, "_raw_", string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss')),'.mat');
        
        cd ../../patients/
        cd(PID)
        cd('Uncalibrated Data');        
        save(backup, 'rawData', 'data_time','time_stamped');
        cd(curr_dir);
        
    case 'Toss'
        time_stamped = datestr(now,'HH:MM:SS');
        tic;
        timestamp1 = '0';
        while ~strcmp(timestamp1, time_stamped) && (s.NumBytesAvailable > 61)
            if firstPass
                line = read(s,60,'char');
                %fprintf('\n');
                timestamp1 = retrieve_CGtimestamp(line);
                firstPass = false;
            else
                line = read(s,61,'char');
                %fprintf('\n');
                timestamp1 = retrieve_CGtimestamp(line);
            end           
        end
    
    case 'End'        
        write(s,3,'uint8');
        fprintf(datestr(now,'HH:MM:SS:FFF'));
        fprintf('\n');
        
end