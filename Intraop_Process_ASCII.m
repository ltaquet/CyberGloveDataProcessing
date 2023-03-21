
%REPLACE WITH YOUR TEKSCAN DATA DIRECTORY
starting_dir = 'OR Code\CyberGlove\Tekscan\Patients';
cd(starting_dir)

% Which patient?

patients = dir('*AWAKE*');
patients = patients(2:end);
patients = struct2cell(patients);
patients = patients(1,:);
PID = listdlg('Name','Patient ID?', 'PromptString','Patient ID?','ListString',patients,...
    'SelectionMode','single',...
    'ListSize',[200 100]);

if isempty(PID)
    fprintf("Aborted\n");
    return
end
PID = patients{PID};

cd(PID);

%%
cd('intraop');

%%



%Load raw ASCII data

% [baseFileName, folderName, ~] = uigetfile('*.csv');
% if ~isequal(baseFileName, 0)
%     csvFileName = fullfile(folderName, baseFileName);
% end

unprocessed_files = dir('*.csv');

for i = 1:1:length(unprocessed_files)
    
    %%
    raw = readmatrix(unprocessed_files(i).name);
    
    %%
    
    raw(length(raw),:)=[]; %If exported as Pressure-reads in pressure
    frame=linspace( 1,length(raw)/17,length(raw)/17)';
    frameST=(frame*17)-16;
    [c1f, c2f] = butter(4,[  20/200*2], 'low');
    [c1f2, c2f2] = butter(4,[  5/200*2], 'low');
    for j=1:length(frameST)
        data(:,:,j)=raw(frameST(j):frameST(j)+16,:);
    end
    data_f = filtfilt( c1f, c2f, data(2:17,:,:));
    for r=1:16
        for c=1:15
            data_f(r,c,:) = filtfilt( c1f2, c2f2, reshape(data_f(r,c,1:end),size(data_f,3),[]));
        end
    end
    
    
    sumF= (0.1747*filtfilt( c1f, c2f, reshape(data(1,9,:),[],1)))-0.0536;
    
    indexarr=reshape(linspace(1,240,240),16,15);
    for j=1:240
        [r,c]=find(indexarr==j);
        dat2d(j,:)=data_f(r,c,:);
    end
    pcaDat=dat2d;
    SumF=sum(pcaDat);
    
    
    datfilt=filtfilt( c1f2, c2f2,pcaDat');
    datfilt(datfilt<20)=nan;
    datSTD=nanstd(datfilt,[],2);
    datmu=nanmean(datfilt,2);
    datCV=(datSTD./datmu)*100;
    st=1;
    et=length(sumF);
    
    
    
    dat2d_g = dat2d(:,:);
    data_g = data(:,:,:);
    dat2d_g = dat2d(:,:);
    data_f_g = data_f(:,:,:);
    datCV_g = datCV(:);
    datfilt_g = datfilt(:,:);
    datmu_g = datmu(:);
    datSTD_g = datSTD(:);
    frame_g = frame(:);
    frameST_g = frameST(:);
    pcaDat_g = pcaDat(:,:);
    sumF_g = sumF(:);
    
    save(strcat(unprocessed_files(i).name(1:end-4),'.mat'), 'dat2d_g', 'data_g', 'dat2d_g', 'data_f_g', 'datCV_g', 'datfilt_g', 'datmu_g', 'datSTD_g', 'frame_g', 'frameST_g', 'pcaDat_g', 'sumF_g');
    clear dat2d data
        
    
end