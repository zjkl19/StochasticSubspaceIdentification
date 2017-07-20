
clear;clc;
chn=[6	12	15	22	31	38	96	103	143	150	155];   %灌河大桥的竖向通道
chns=size(chn,2);   %通道数

yearFolderName='20x';   %20xx年 文件夹名称
DayFolderName='20150204';
MatFileName='2015-02-04 00-09-19.mat';

load([pwd '\' yearFolderName '\' DayFolderName '\' MatFileName]);

if exist('data','var')
    RawData=data(:,chn);
else
    RawData=Data0(:,chn);
end
%RawData=load(ViewObj.MPView.PathInfo); %读取原始数据

n=10;   %压缩参数

%------对原始数据进行滤波----
OriginalDate=RawData;                       %读取原始数据
RowNum=size(OriginalDate,1);                      %读取行数
CloumnNum=size(OriginalDate,2);                   %读取列数
if (mod(RowNum,n)==0)
    FinalDate=zeros(RowNum/n,CloumnNum);
else
    FinalDate=zeros(fix(RowNum/n)+1,CloumnNum);
end
for i=1:CloumnNum
    Transition=OriginalDate(:,i);                 %提取一列
    Transition=decimate(Transition,n);            %滤波
    FinalDate(:,i)=Transition;                    %加入新矩阵
end
%----------------------------
RawData=FinalDate;

Fs=5;  %重采样后的采样频率
segs=4; %分段数
L=size(RawData,1);      %数据长度
nfft=2^nextpow2(L);     %傅里叶变换点数
w=hamming(nfft/segs);    %hamming海明窗，调用方式为w=hamming(n),返回一个n点海明窗函数值得列向量w
noverlap=length(w)/2;       %重叠段长度

for i=1:chns
    signal=RawData(1:L,i);
    [psdz(:,i),f]=pwelch(signal,w,noverlap,nfft,Fs);
end

anpsdz(1,:)=GetANPSD(psdz,chns); 
dbAnpsdz=10*log10(anpsdz);
plot(f,dbAnpsdz);

