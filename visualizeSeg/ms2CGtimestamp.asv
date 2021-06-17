function [CGtimestamp] = ms2CGtimestamp(msString)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    [decimalpt, ~] = regexp(msString,'\.');
    ms = str2double(extractBetween(msString,decimalpt,strlength(msString)));
    sample_v = ["0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" "0S" "1S" "2S" ];
    sample_ind = 90 * (ms);
    
    HMS = extractBetween(msString,1,decimalpt-1);
    
    thirty = floor(sample_ind./3);
  
    
    if thirty < 10
        stThirty = strcat('0',int2str(thirty));
        if thirty == 0
            sample_ind = sample_ind + 1;
        end
    else
        stThirty = int2str(thirty);
    end
    
    CGtimestamp = strcat(HMS,':',stThirty,':',sample_v(floor(sample_ind)));
    
end

