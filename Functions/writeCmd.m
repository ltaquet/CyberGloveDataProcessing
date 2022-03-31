function [success] = writeCmd(device,input,fileORtime)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numCharStart = device.NumBytesAvailable;

switch input
    
    case '1ew'
        write(device,input,'string');
        
        
    case '1dw'
        write(device,input,'string');
       
    case '1m'
        write(device,input,'string');
        write(device,3,'uint8');
        
    case '1es'
        write(device,input,'string');
        
    case '1ds'
        write(device,input,'string');
        
    case '1eu'
        write(device,input,'string');
        
    case '1du'
        write(device,input,'string');
        
    case '1w'
        write(device,input,'string');
        write(device,1,'uint8');
        
    case '1u'
        write(device,input,'string');
        write(device,1,'uint8');
       
    case '1s'
        write(device,input,'string');
        write(device,1,'uint8');
       
    case '1ts'
        write(device,strcat(input,fileORtime),'string');
       
    case 'STOP'
        write(device,3,'uint8');
       
end
        success = true;
end

