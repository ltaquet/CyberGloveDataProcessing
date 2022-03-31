cd(fileparts(which('SimpleDeBugLeft.m')));
addpath('Functions');

%APP INIT
s = serialport("COM4", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;
pause(10)

writeCmd(s,'1ds','');
pause(1)
writeCmd(s,'1eu','');
writeCmd(s,'1dw','');
writeCmd(s,'1u','');
pause(1)



pause(2)
write(s,"1S",'string');
pause(5)
write(s,3,'uint8');
read(s,s.NumBytesAvailable,'string')