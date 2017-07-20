%函数名称:rmAbnormWD
%函数功能:利用基于索引的异类挖掘剔除异常数据
%详见《数据挖掘》第二版 朱明 P258
%传入参数:WD,WD_DR,WD_Mode:剔除异常数据前的频率，阻尼比和模态
%返回参数:wd,wd_DR,wd_Mode:剔除异常数据后的频率，阻尼比和模态
function [wd,wd_DR,wd_Mode]=rmAbnormWD(WD,WD_DR,WD_Mode)

minDist=0.005;  %距离阈值
minNodes=3;     %异常值在距离阈值范围内最多所具有的点数

nwd=size(WD,1); %未剔除异常点前，稳定点的个数
wd_dist=pdist(WD(:,1));    %距离矩阵: wd_dist(i,j)表示第i个稳定点和第j个稳定点的距离

distSqr = squareform(wd_dist);

statNodes=zeros(1,nwd); %各点在距离阈值范围内所具有的点数（除自身）

deleLanda=[];   %剔除定位向量

for i=1:nwd
    statNodes(1,i)=numel((find(distSqr(i,:)<=minDist)))-1;      %减1的原因是：自身对自身的情况要扣除
    if statNodes(1,i)<minNodes
        deleLanda=[deleLanda;i];
    end
end
WD(deleLanda,:)=[];
wd=WD;
if nargin>1
    WD_DR(deleLanda)=[];
    WD_Mode(:,deleLanda)=[];
    wd_DR=WD_DR;
    wd_Mode=WD_Mode;
end


    
