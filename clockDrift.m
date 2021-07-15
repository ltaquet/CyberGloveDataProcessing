
clc; clear
s = serialport("COM6", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;

write(s,"1ts",'string');

%sets CyperGlove clock to current time
curr_time = datestr(now,'HH:MM:SS');
write(s,curr_time,'string');

pause(2)

d = zeros(1,(60*15/5));
t = zeros(1,(60*15/5));
min = 60;
samp = 1;
flush(s);

for i = 5:5:(60*min)
pause(5)

fprintf('Progress: ');
prog = floor((i/(60*min))*100);
fprintf(int2str(prog));
fprintf('\n');

t2 = datestr(now,'HH:MM:SS:FFF');
write(s,"1tg",'string');
read(s,3,'char');
t1 = read(s,s.NumBytesAvailable,'char');
t1 = strcat(t1(1:end-3),int2str((floor(str2double(t1(end-2:end-1))/30*100))));
t1(end-2) = '.';
t2(end-3) = '.';
t2 = t2(1:end-1);
a = {t1 t2};

td = duration(a,'inputformat','hh:mm:ss.SS');



d(samp) = milliseconds(diff(td));
t(samp) = i;
samp = samp + 1;
end

plot(t(~isnan(d)), d(~isnan(d)));
coefs = polyfit(t(~isnan(d)), d(~isnan(d)), 1);
y = coefs(2)+(coefs(1)*t);
hold on
plot(t,y);title(num2str(coefs(1)));

save('drift2.mat','d','t','y','coefs');