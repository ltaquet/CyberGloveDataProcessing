
 clear; clc;
 f = msgbox('Select CG III raw MAT file');
 uiwait(f);
 [file2,path2] = uigetfile('*.mat');
 load(file2);
 
 load('Brian_C_right_cal.mat');
 
 [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,90);
 
 load('Brian_C_right_auto_cal.mat');
 
 [angles_auto,angles_deg_auto,angles_f_auto,angles_deg_f_auto] = calibrateCGdata(rawData,offsets,gains,90);
 
 save('manVSautoTEST.mat', 'angles', 'sensors', 'rawData', 'angles_deg','angles_f','angles_deg_f',...
      'angles_auto', 'angles_deg_auto','angles_f_auto','angles_deg_f_auto');