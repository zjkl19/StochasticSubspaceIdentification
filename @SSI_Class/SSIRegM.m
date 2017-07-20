%类方法名:SSIRegM(obj)
%类方法功能:将稳定图中的所有振型标准化（第1个测点归一化）
%传入参数:obj,ThisShape:欲归一化的振型
%返回参数:obj.RegShape

function obj=SSIRegM(obj,ThisShape)
    [m n p]=size(ThisShape);
    if ~m || ~n || ~p
        error ('Wrong Shape size.');
    end
    for k=1:p           %遍历各阶系统
        for j=1:n       %对kk阶系统逐阶模态进行归一化（遍历各阶模态）
            if ThisShape(1,j,k)~=0      %将第1个元素归一化
                    div=ThisShape(1,j,k);   %储存除数
            end
            for i=1:m   %遍历各个元素                
                ThisShape(i,j,k)=ThisShape(i,j,k)/div;           
            end
        end
    end
    obj.RegShape=ThisShape;

end