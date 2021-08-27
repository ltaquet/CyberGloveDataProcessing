%clockDrift script
% Description: Initializes CyberGlove with MATLAB Clock before sampling 
%              both the CyberGlove clock and MATLAB clock every 5 seconds
%              to characterize clock drift over time

addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove');

% Initialize CyberGlove Settings
clc; clear
s = serialport("COM6", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;

%sets CyperGlove clock to current time
write(s,"1ts",'string');
curr_time = datestr(now,'HH:MM:SS');
write(s,curr_time,'string');

%Allows the CyberGlove to finish setting clock before sending new commands
pause(2)

% preallocates MATLAB vs CG time difference and total seconds array
d = zeros(1,(60*15/5));
t = zeros(1,(60*15/5));

%60 seconds in a minute
min = 60;

%Sample number initialized to start at 1
samp = 1;

%Flushes serial port of CyberGlove
flush(s);

%Loops for 60minutes sampling both clocks every 5 seconds
for i = 5:5:(60*min)

pause(5) % Waits between each sample

% Displays percent progress since no data is shown until the end of 60min
fprintf('Progress: ');
prog = floor((i/(60*min))*100);
fprintf(int2str(prog));
fprintf('\n');

% MATLAB clock sample
t2 = datestr(now,'HH:MM:SS:FFF');

% CyberGlove clock sample
write(s,"1tg",'string');
read(s,3,'char');
t1 = read(s,s.NumBytesAvailable,'char');

%Converts CG sample number in timestamp to milliseconds like MATLAB
t1 = strcat(t1(1:end-3),int2str((floor(str2double(t1(end-2:end-1))/30*100))));

%Replace colon in ms of timestamp to decimal
t1(end-2) = '.';
t2(end-3) = '.';
t2 = t2(1:end-1);
a = {t1 t2};

%Calculates time difference between MATLAB and CG clocks
td = duration(a,'inputformat','hh:mm:ss.SS');
d(samp) = milliseconds(diff(td))

%Keeps track of the seconds since the start for each sampled difference
t(samp) = i;

%Increments sample number
samp = samp + 1;
end

%Plots differences over time
plot(t(~isnan(d)), d(~isnan(d)));

%Plots linearization for the sampled differences
coefs = polyfit(t(~isnan(d)), d(~isnan(d)), 1);
y = coefs(2)+(coefs(1)*t);
hold on
plot(t,y);title(num2str(coefs(1)));

save('drift2.mat','d','t','y','coefs');