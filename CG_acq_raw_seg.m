function CG_acq_raw_seg(cmd ,port, PID)
%CG_acq_raw_seg Allows for initializing, starting, stopping, and saving of CyberGlove
%recordings
%CyberGlove stream using an established com port to a CyberGlove.
%   Detailed explanation goes here

s = port;
curr_dir = pwd;

switch cmd
    
    case 'Initialize'
        % Enables Wifi Streaming
        write(s,"1m",'string');
        write(s,3,'uint8');
        write(s,"1ds",'string');
        write(s,"1du",'string');
        write(s,"1ew",'string');
        write(s,"1w",'string');
        write(s,1,'uint8');
        write(s,"1s",'string');
        write(s,1,'uint8');
        pause(1)
        numBytes = s.NumBytesAvailable;
        write(s,1,'uint8');
        pause(3);
        write(s,1,'uint8');
        pause(1);
        

        %sets CyperGlove clock to current time
        write(s,"1ts",'string');
        curr_time = datestr(now,'HH:MM:SS');
        write(s,curr_time,'string');
        
    case 'Start'

        flush(s);
        
        write(s,"1S",'string'); tic;
        pause(1)
       
        
    case 'Save'
 
        write(s,3,'uint8');
 
        
        recievedData = s.NumBytesAvailable;
        pause(1);
        while recievedData ~= s.NumBytesAvailable
            recievedData = s.NumBytesAvailable;
            pause(1);
        end
        read(s,2,'char');
        cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients');
        cd(PID);
        cd('Raw Data');
        fileID = fopen(strcat(PID, "_", ...
            string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss'))),'w');
        fwrite(fileID,read(s,s.NumBytesAvailable,'uint8'),'uint8');
        fclose(fileID);
        cd(curr_dir);
        
        pause(1)
        
        flush(s);
        
    case 'Stop'
        write(s,3,'uint8');
        
        recievedData = s.NumBytesAvailable;
        pause(1);
        while recievedData ~= s.NumBytesAvailable
            recievedData = s.NumBytesAvailable;
            pause(1);
        end
        flush(s);
end