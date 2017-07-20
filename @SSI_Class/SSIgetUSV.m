function obj=SSIgetUSV(obj)
%函数名称:SSIgetUSV
%函数功能:计算奇异值分解后的U、S、V矩阵
%传入参数:obj
%返回参数:obj
if obj.methodID==1
    obj=obj.SSI_Cov;
elseif obj.methodID==2
    obj=obj.SSI_Date;
else
    error('Error method ID.');
end
end

