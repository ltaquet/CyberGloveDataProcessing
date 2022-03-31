cd(fileparts(which('DeBugLeftGlove.m')));
addpath('Functions');

%APP INIT
s = serialport("COM4", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;
pause(5)

writeCmd(s,'1ds','');
pause(1)
writeCmd(s,'1eu','');
writeCmd(s,'1dw','');
writeCmd(s,'1u','');
pause(1)


%START
% write(s,"1m",'string');
% write(s,3,'uint8');
write(s,"1es",'string');

writeCmd(s,'1eu','');
writeCmd(s,'1dw','');
% writeCmd(s,'1u','');
% pause(1)
write(s,"1s",'string');
write(s,1,'uint8');
write(s,"1A",'string');
binFile = strcat('leon_t', "_", string(datetime('now','Format','yyyy_MM_dd_HH_mm_ss')));
write(s,binFile,'string');
pause(1)

write(s,1,'uint8');
pause(1);
write(s,1,'uint8');
pause(1);

% write(s,"1ts",'string');
% 
% %sets CyperGlove clock to current time
% curr_time = datestr(now,'HH:MM:SS');
% write(s,curr_time,'string');




write(s,"1S",'string'); 

pause(5)

write(s,3,'uint8'); 
pause(2)
read(s,s.NumBytesAvailable,'char') 
