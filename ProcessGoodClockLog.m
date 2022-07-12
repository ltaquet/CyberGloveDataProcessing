function [initLag,startClocks,endClocks, delays] = ProcessGoodClockLog(logPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')
Log = readmatrix(logPath);
opts = detectImportOptions(logPath);

Init = readmatrix(logPath,delimitedTextImportOptions('DataLines',[1 Inf]));

GCts = char(Init(1,2));
GoodClock.time = datetime(GCts(1:21),'InputFormat','yyyy_MM_dd___HH_mm_ss');
fractionalSecond = char(Init(1,2));
GoodClock.fs = str2num(fractionalSecond(23:end));



CyberClock = CGtimestamp2ms(char(Init(2,2)),GoodClock.time);

initLag = frameLag(GoodClock,CyberClock);
index = 1;

for i = 1:3:length(Log)-2
    GoodClockStart.time = datetime(2022,Log(i,2),Log(i,3),Log(i,6),Log(i,7),Log(i,8));
    GoodClockStart.fs = Log(i,9);
    
    GoodClockStream.time = datetime(2022,Log(i+1,2),Log(i+1,3),Log(i+1,6),Log(i+1,7),Log(i+1,8));
    GoodClockStream.fs = Log(i+1,9);
    
    GoodClockStop.time = datetime(2022,Log(i+2,2),Log(i+2,3),Log(i+2,6),Log(i+2,7),Log(i+2,8));
    GoodClockStop.fs = Log(i+2,9);
    
    startClocks(index) = GoodClockStart;
    delays(index) = frameLag(GoodClockStart,GoodClockStream);
    endClocks(index) = GoodClockStop;
    index = index + 1;
end



end

