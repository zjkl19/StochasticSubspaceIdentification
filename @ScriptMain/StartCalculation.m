
%进行奇异值分解，计算投影矩阵，计算各阶系统情况下，结构的模态参数
function StartCalculation(obj,ViewObj)

tic;    %计时开始
disp('开始计算，正在计算中……');

RawData=load(ViewObj.MPView.PathInfo); %读取原始数据
obj.SSIObj=SSI_Class('SSIConfigFile.txt',RawData);     %类实例化
obj.SSIObj=obj.SSIObj.PPsvd;
obj.SSIObj=obj.SSIObj.SSITable(obj.SSIObj.NN);

disp('计算完成!');
toc;    %计时结束
end