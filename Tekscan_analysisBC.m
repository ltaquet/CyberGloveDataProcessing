
%% Do not need
% directory=pwd;
% Files = dir([directory,'\*.csv']);
% raw=readmatrix(Files.name);
% raw(length(raw),:)=[]; %If exported as Pressure-reads in pressure
% %calibrated=(0.1747*raw)-0.0536;
% frame=linspace( 1,length(raw)/17,length(raw)/17)';
% frameST=(frame*17)-16;

%%
% Load file of Interest

cd(fileparts(which('Tekscan_analysisBC.m')))

[c1f, c2f] = butter(4,[  20/200*2], 'low');
[c1f2, c2f2] = butter(4,[  5/200*2], 'low');

data_f = filtfilt( c1f, c2f, data(2:17,:,:));
for r=1:16
    for c=1:15
        data_f(r,c,:) = filtfilt( c1f2, c2f2, reshape(data_f(r,c,1:end),size(data_f,3),[]));
    end
end



%plot(pcaDat')
sumF= (0.1747*filtfilt( c1f, c2f, reshape(data(1,9,:),[],1)))-0.0536;


indexarr=reshape(linspace(1,240,240),16,15);
for i=1:240
    [r,c]=find(indexarr==i);
    dat2d(i,:)=data_f(r,c,:);
end
pcaDat=dat2d;
SumF=sum(pcaDat);

%plot(sumF)
datfilt=filtfilt( c1f2, c2f2,pcaDat');
datfilt(datfilt<20)=nan;
datSTD=nanstd(datfilt,[],2);
datmu=nanmean(datfilt,2);
datCV=(datSTD./datmu)*100;
st=1;
et=length(sumF);
% changed the below to increase 'MinPeakProminence from 50 to 150 and added
% 'MinPeakDistance', ended up on 1000 after trial and error, need to verify
% this is the best option with actual practice data
[MaxF,MaxT]=findpeaks(sumF(st:et),'MinPeakProminence',70,'MinPeakDistance',900,'SortStr','none');MaxT=MaxT+st-1;
%
tMVC=table(MaxF,MaxT);
writetable(tMVC,'Grip_MVC','delimiter','\t');
for z=1:length(MaxT);
    %
%%%%%%%%%%% Find peaks on 2D array %%%%%%%%%%%%%%%
targetmap=zeros(16,15);

[xymax,smax,xymin,smin] = extrema2(data_f(:,:,MaxT(z)));

[RI1,CI1]=find(indexarr==smax(1));
[RI2,CI2]=find(indexarr==smax(2));
if RI2>RI1
    TColI=CI1;
    ThumbColI=CI2;
else
    TColI=CI2;
    ThumbColI=CI1;
end
    
% [~,TColI]=find(indexarr==smax(1));
% [~,ThumbColI]=find(indexarr==smax(2));
% LocTarW;
%
%%%%%%%%%%%%%%% Target Finger %%%%%%%%%%%%%%%%%%


[PkTarL,LocTarL,WidthTarL,PromTarL]=findpeaks(padarray(data_f(1:8,TColI,MaxT(z)),1),'SortStr','descend','nPeaks',1);
LocTarL-1;
TarLmin=round(LocTarL-(WidthTarL/2));TarLmax=round(LocTarL+(WidthTarL/2));
if TarLmin<1
    TarLmin=1; TarLmax=TarLmin+round(WidthTarL);
end

PkTarW=[];LocTarW=[];WidthTarW=[];PromTarW=[];LocTarW=NaN(TarLmax,1);
for TarW=TarLmin:TarLmax
    [PkTarW(TarW,:),LocTarW(TarW,:),WidthTarW(TarW,:),PromTarW(TarW,:)]=findpeaks(data_f(TarW,:,MaxT(z)),'SortStr','descend','nPeaks',1);
end
dLoc=vertcat(0,diff(LocTarW));
for i=TarLmin:length(LocTarW)
    if dLoc(i)> 2*nanmean(dLoc(1:i-1))
       LocTarW(i)=nanmean(LocTarW(1:i-1))+nanmean(dLoc(1:i-1));
    elseif dLoc(i)< -2*nanmean(dLoc(1:i-1))
       LocTarW(i)=nanmean(LocTarW(1:i-1))-nanmean(dLoc(1:i-1));
    end
end
TarWmin=round(LocTarW-(WidthTarW/2));TarWmax=round(LocTarW+(WidthTarW/2));

targetmap(TarLmin:TarLmax,TColI)=1;
for tm=TarLmin:TarLmax
    targetmap(tm,TarWmin(tm):TarWmax(tm))=1;
end
%

%%%%%%%%%%%%%%% Thumb %%%%%%%%%%%%%%%%%%

[PkThL,LocThL,WidthThL,PromThL]=findpeaks(padarray(data_f(9:end,ThumbColI,MaxT(z)),1),'SortStr','descend','nPeaks',1);LocThL=LocThL+9;
ThLmin=round(LocThL-(WidthThL/2));ThLmax=round(LocThL+(WidthThL/2));

if ThLmax>16
    ThLmax=16; ThLmin=ThLmax-round(WidthTarL);
end

for ThW=ThLmin:ThLmax
    [PkThW(ThW,:),LocThW(ThW,:),WidthThW(ThW,:),PromThW(ThW,:)]=findpeaks(data_f(ThW,:,MaxT(z)),'SortStr','descend','nPeaks',1);
end
ThWmin=round(LocThW-(WidthThW/2));ThWmax=round(LocThW+(WidthThW/2));

targetmap(ThLmin:ThLmax,ThumbColI)=1;
for tm=ThLmin:ThLmax
    targetmap(tm,ThWmin(tm):ThWmax(tm))=1;
end

% 
% for p=1:16
%     [PkV(:,p),Loc(:,p),Width(:,p),Prom(:,p)]=findpeaks(data_f(p,:,MaxT(z)),'nPeaks',1)
% end

%

[R,C]=find(targetmap==1);

% thumb=[reshape(data_f(4,10,:),[],1)-mean(data_f(4,10,1:100)),reshape(data_f(3,10,:),[],1)-mean(data_f(3,10,1:100)),reshape(data_f(5,10,:),[],1)-mean(data_f(5,10,1:100)),reshape(data_f(6,10,:),[],1)-mean(data_f(6,10,1:100))];
% middle=[reshape(data_f(16,9,:),[],1)-mean(data_f(16,9,1:100)),reshape(data_f(15,9,:),[],1)-mean(data_f(15,9,1:100)),reshape(data_f(14,9,:),[],1)-mean(data_f(14,9,1:100))];
% tm=[thumb,middle];
pinchF=[];
for i=1:length(R)
    pinchF(i,:)=filtfilt( c1f, c2f, reshape(data_f(R(i),C(i),:),[],1)-mean(data_f(R(i),C(i),1:100)));
end

tmGroup=sqrt(sum(pinchF.^2,1));
indivArr=data_f;

% indivArr(4,10,:)=NaN;indivArr(3,10,:)=NaN;indivArr(5,10,:)=NaN;indivArr(6,10,:)=NaN;
% indivArr(16,9,:)=NaN;indivArr(15,9,:)=NaN;indivArr(14,9,:)=NaN;
for i=1:length(R)
    indivArr(R(i),C(i),:)=NaN;
end

indMat=reshape(indivArr,[],length(sumF));indMat=(indMat-mean(indMat(:,1:100),2))';
elseMap=sqrt(nansum(indMat.^2,2));
[mx,mxT]=(max(tmGroup));
tmGroup=tmGroup./mx;elseMap=elseMap./mx;
PI=1-(elseMap./tmGroup');
PinchIndiv(z,:)=PI(MaxT(z));




end
tPI=table(PinchIndiv);
writetable(tPI,'PinchIndividuation','delimiter','\t');
%
% plot(tmGroup,'k')
% hold on
% plot(elseMap,'g')
% plot(PI,'b')
PItitles=string(round(PinchIndiv,2));

figure;
for i=1:2; subplot(1,2,i);
Im=pcolor(data_f(:,:,MaxT(i)));cb=colorbar;colormap jet;caxis([0,max(max(data_f(:,:,MaxT(i))))]);
Im.LineStyle='None';Im.FaceColor='Interp';ylabel(cb, 'Pressure (N/cm^2)');
set(gca,'FontSize',16); ylabel('Sensor Rows');xlabel('Sensor Columns');
t = title(PItitles(i), 'Units', 'normalized', 'Position', [0, 1.01, 0]);
end
for i=1:2; subplot(1,2,(i+1));
plot(frame(st:et)/200,sumF(st:et),'k','LineWidth',2);box off; ax=gca;ax.LineWidth=2;ax.TickDir='Out';hold on;
for i=1:2;line([MaxT(i)/200,MaxT(i)/200],[0,200],'color','b');end;hold off;ylabel('Force (N)');xlabel('Time (s)');
set(gca,'FontSize',16);
t = title('Pressure Sum', 'Units', 'normalized', 'Position', [0, 1.01, 0]);
end


