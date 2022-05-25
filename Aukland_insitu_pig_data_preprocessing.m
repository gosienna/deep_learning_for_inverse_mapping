%% data preprocessing for pig 5 data
%% load data
path_ecg="D:\back up2\Google Drive2\Project\electrocardiac imaging\The Experimental Data and Geometric Analysis Repository (EDGAR) dataset\InSitu Animal\Auckland-2012-06-05\20200326send_by_laura\Pig1\Signals\";
% path_ecg="/Users/chenkewei/Google Drive/Project/electrocardiac imaging/The Experimental Data and Geometric Analysis Repository (EDGAR) dataset/InSitu Animal/Auckland-2012-06-05/20200326send_by_laura/Pig5/Signals/" ;
sites=[2 29 30 133 159 189 214 223]; %pig 1
% sites=[18 23 68 101 140 158 166 184 209 229];%pig 5

i=length(sites);
ecg_ts_all=cell(1,i);
ecg_cs_all=cell(1,i);
for j=1:i
name="EpiPacingSite-"+sites(j)+".mat";
load(path_ecg+name);
vest_pol=rec.vest.Ve;
sock_pol=rec.sock.Ve;
ecg_ts_all{1,j}=vest_pol;
ecg_cs_all{1,j}=sock_pol;
end

%% get failed lead
list_cs=linspace(1,239,239);
i=length(ecg_cs_all);
for j=1:i
    ecg_cs=ecg_cs_all{1,j};
    for j=1:239
        if ecg_cs(j,10)==0 && ecg_cs(j,20)==0 && ecg_cs(j,30)==0  
            list_cs(j)=0;
        end
end
end

%% 
list_ts=linspace(1,170,170);
len=length(ecg_ts_all);
for i=1:len
    ecg_ts=ecg_ts_all{1,len};
    for j=1:170
        if ecg_ts(j,10)==0 && ecg_ts(j,20)==0 && ecg_ts(j,30)==0  
            list_ts(j)=0;
        end
    end
end

%% filtered out failed leads
ecg_cs=cell(1,10);
ecg_ts=cell(1,10);
for j=1:10
    raw_ecg=ecg_cs_all{1,j};
    new_ecg=zeros(192,length(raw_ecg));
    ii=1;
    for node=1:239
        if list_cs(node)~=0
            new_ecg(ii,:)=raw_ecg(node,:);
            ii=ii+1;
        end
    end
    ecg_cs{1,j}=new_ecg;
   
    
    raw_ecg=ecg_ts_all{1,j};
    new_ecg=zeros(102,length(raw_ecg));
    ii=1;
    for node=1:170
        if list_ts(node)~=0
            new_ecg(ii,:)=raw_ecg(node,:);
            ii=ii+1;
        end
    end
    ecg_ts{1,j}=new_ecg;
end
%% 
x=0;
for j=1:239
    if list_cs(j)~=0
        x=x+1;
    end
end

%% ----------------------main code area--------------------------
cs_pig1_epi_filltered=cell(1,8);
ts_pig1_epi_filltered=cell(1,8);
for j=1:8
[cs,ts]=ecg_preprocessing(ecg_cs_all{1,j},ecg_ts_all{1,j});
end

%% get single beat out
pig1_cs=cell(1,8);
pig1_ts=cell(1,8);
for j=1:1
[cs,ts]=QRS_extract(ecg_cs_all{1,j},ecg_ts_all{1,j});
pig1_cs{1,j}=cs;
pig1_ts{1,j}=ts;
end
%% 
new_ecg_ts=bandstop(ecg_ts_all{1,1}',[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
%% 
[~,lct]=findpeaks(new_ecg_ts(:,1),'MinPeakHeight',0.6);
%% 
for j=8:8
[cs,ts]=QRS_extract(ecg_cs{1,j},ecg_ts{1,j});
pig5_cs{1,j}=cs;
pig5_ts{1,j}=ts;
end

%% -----------------------prototyping-----------------------------
%% 
raw_ecg=ecg_ts{1,8}';
new_ecg=ecg_ts{1,8}';
new_ecg=bandstop(raw_ecg,[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
%% apply moving mean
node=1;
% [pkt,lct]= findpeaks(new_ecg(:,node),'MinPeakHeight',0.2,'MaxPeakWidth',10);
findpeaks(new_ecg(:,node),'MinPeakHeight',0.6);
%%
num_p=length(lct);
% segment at head
seg=new_ecg(1:lct(1)-5,:);
% segment at tail
seg=new_ecg(lct(num_p)+5:end,:);
seg=movmean(seg,32);
new_ecg(lct(num_p)+5:end,:)=seg;
new_ecg(lct(num_p)-5:lct(num_p)+5,:)=new_ecg(lct(num_p)-5:lct(num_p)+5,:)-repmat(seg(2,:),11,1);
%segmetn in the body
for j=1:num_p-1
seg=new_ecg(lct(j)+5:lct(j+1)-5,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m; % bring seg mean to zero
new_ecg(lct(j)+5:lct(j+1)-5,:)=seg;
new_ecg(lct(j)-5:lct(j)+5,:)=new_ecg(lct(j)-5:lct(j)+5,:)-repmat(m,11,1);
end

%% 
seg=new_ecg(lct(1)+5:lct(2)-5,node);
seg=movmean(seg,32);
plot(new_ecg(lct(1)+5:lct(2)-5,node));
hold on
plot(seg)
%% -----------------------prototyping2-----------------------------
raw_ecg=ecg_ts_all{1,2}';
new_ecg=bandstop(raw_ecg,[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
[pkt,lct]=findpeaks(new_ecg(:,2),'MinPeakHeight',0.2,'MaxPeakWidth',6,'MinPeakProminence',0.1);
% findpeaks(new_ecg(:,2),'MinPeakHeight',0.2,'MaxPeakWidth',8,'MinPeakProminence',0.1);
num_p=length(lct);
ecg_seg=cell(1,length(lct)-1);
for j=1:num_p-1
    seg=movmean(new_ecg(lct(j)+10:lct(j+1)-10,:),32,1);
    seg=seg-repmat(mean(seg),length(seg),1);
    ecg_seg{1,j}=seg;
end
%% ----------------------testing area-----------------------------------------
node=2;
plot(movmean(new_ecg((lct(1)+10:lct(2)-10),node),32,1));
hold on
plot(ecg_seg{1,1}(:,node))
hold on

%% 
node=2;
for j=1:17
plot(ecg_seg{1,j}(:,node));
hold on
end
%% 
plot(test_ts(2,:))
hold on
plot(ecg_ts_all{1,10}(2,:))
%% -----------------------function for signal filtering and zero mean-----------------------------
function [new_ecg_cs,new_ecg_ts]=ecg_preprocessing(raw_ecg_cs,raw_ecg_ts)
new_ecg_cs=bandstop(raw_ecg_cs',[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
new_ecg_ts=bandstop(raw_ecg_ts',[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
% apply moving mean and zero mean
node=3;
[~,lct]= findpeaks(new_ecg_cs(:,node),'MinPeakHeight',0.3,'MinPeakProminence',0.5);
num_p=length(lct);
% segment at head
seg=new_ecg_cs(1:lct(1)-5,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m;
new_ecg_cs(1:lct(1)-5,:)=seg;

seg=new_ecg_ts(1:lct(1)-5,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m;
new_ecg_ts(1:lct(1)-5,:)=seg;
% segment at tail
seg=new_ecg_cs(lct(num_p)+5:end,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m;
new_ecg_cs(lct(num_p)+5:end,:)=seg;
new_ecg_cs(lct(num_p)-5:lct(num_p)+5,:)=new_ecg(lct(num_p)-5:lct(num_p)+5,:)-repmat(seg(2,:),11,1);

seg=new_ecg_ts(lct(num_p)+5:end,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m;
new_ecg_ts(lct(num_p)+5:end,:)=seg;
new_ecg_ts(lct(num_p)-5:lct(num_p)+5,:)=new_ecg(lct(num_p)-5:lct(num_p)+5,:)-repmat(seg(2,:),11,1);
%segmetn in the body
for i=1:num_p-1
seg=new_ecg_cs(lct(i)+5:lct(i+1)-5,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m; % bring seg mean to zero
new_ecg_cs(lct(i)+5:lct(i+1)-5,:)=seg;
new_ecg_cs(lct(i)-5:lct(i)+5,:)=new_ecg(lct(i)-5:lct(i)+5,:)-repmat(m,11,1);

seg=new_ecg_ts(lct(i)+5:lct(i+1)-5,:);
seg=movmean(seg,32);
m=mean(seg);
seg=seg-m; % bring seg mean to zero
new_ecg_ts(lct(i)+5:lct(i+1)-5,:)=seg;
new_ecg_ts(lct(i)-5:lct(i)+5,:)=new_ecg(lct(i)-5:lct(i)+5,:)-repmat(m,11,1);
end
new_ecg_cs=new_ecg_cs';
end
%% -----------------------function for signal filtering and zero mean and gather ecg segment 
function [ecg_seg_cs,ecg_seg_ts]=QRS_extract(raw_ecg_cs,raw_ecg_ts)
new_ecg_cs=bandstop(raw_ecg_cs',[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
new_ecg_ts=bandstop(raw_ecg_ts',[0.048 0.05],'Steepness',0.9,'StopbandAttenuation',10);
[~,lct]=findpeaks(new_ecg_ts(:,1),'MinPeakHeight',0.6);
% [~,lct]=findpeaks(new_ecg_ts(:,1),'MinPeakHeight',0.2,'MaxPeakWidth',8,'MinPeakProminence',0.1);
%findpeaks(new_ecg(:,2),'MinPeakHeight',0.2,'MaxPeakWidth',8,'MinPeakProminence',0.1);
num_p=length(lct);
ecg_seg_cs=cell(1,length(lct)-1);
ecg_seg_ts=cell(1,length(lct)-1);
for i=1:num_p-1
    %cs part
    seg=movmean(new_ecg_cs(lct(i)+10:lct(i+1)-10,:),64,1);
    seg=seg-mean(seg);
    ecg_seg_cs{1,i}=seg';
    %ts part use the same peak location
    seg=movmean(new_ecg_ts(lct(i)+10:lct(i+1)-10,:),64,1);
    seg=seg-mean(seg);
    ecg_seg_ts{1,i}=seg';
end
end