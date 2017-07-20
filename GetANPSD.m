%函数名:GetANPSD
%函数功能：求n个点的平均正则化功率谱
%传入参数：pxx:n个点功率谱估计竖坐标值；n:点数
%返回参数：anpsd：平均正则化后的功率谱竖坐标值

function anpsd=GetANPSD(pxx,n)

for i=1:n
    bridge(:,i)=pxx(:,i)./sum(pxx(:,i));  %点除运算，两个同阶矩阵对应元素相除
end

for i=1:length(bridge)
    bridge1(i)=sum(bridge(i,:));
end
anpsd=1/n*bridge1;

end