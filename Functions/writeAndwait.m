function [success] = writeAndwait(device,input,fileORtime)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numCharStart = device.NumBytesAvailable;

switch input
    case '1A'
        write(device,convertStringsToChars(strcat(input,fileORtime)),'string');
        %write(device,input,'string');
        %write(device,fileORtime,'string');
        
        %NOTE: The CyberGlove occasionally drops the first char of a
        %filename so it only waits until 
        while device.NumBytesAvailable-numCharStart < (1 + length(fileORtime))
        end
        if device.NumBytesAvailable-numCharStart > (2 + length(fileORtime))
            error(strcat('Error when setting active file: ', ...
                read(device,device.NumBytesAvailable,'char')));
        end
        write(device,1,'uint8');
        while device.NumBytesAvailable-numCharStart < (2 + length(fileORtime))
        end
%         if device.NumBytesAvailable-numCharStart > (3 + length(fileORtime))
%             error(strcat('Error when setting active file: ', ...
%                 read(device,device.NumBytesAvailable,'char')));
%         end
        %write(device,header,'string');
        write(device,1,'uint8');
        while device.NumBytesAvailable-numCharStart < (5 + length(fileORtime))
        end
%         if device.NumBytesAvailable-numCharStart > (6 + length(fileORtime))
%             error(strcat('Error when setting active file: ', ...
%                 read(device,device.NumBytesAvailable,'char')));
%         end
        
    case '1ew'
        write(device,input,'string');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
        
    case '1dw'
        write(device,input,'string');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1m'
        write(device,input,'string');
        write(device,3,'uint8');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1es'
        write(device,input,'string');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1du'
        write(device,input,'string');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1w'
        write(device,input,'string');
        write(device,1,'uint8');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1s'
        write(device,input,'string');
        write(device,1,'uint8');
        while device.NumBytesAvailable-numCharStart ~= 4
        end
    case '1ts'
        write(device,strcat(input,fileORtime),'string');
        while device.NumBytesAvailable-numCharStart ~= 24
        end
    case 'STOP'
        write(device,3,'uint8');
        while device.NumBytesAvailable-numCharStart ~= 1
        end
end
        success = true;
end

