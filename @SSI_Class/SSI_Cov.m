%类方法名:SSI_Cov
%类功能:基于协方差驱动的随机子空间方法
%传入参数:obj
%返回参数:obj

function obj=SSI_Cov(obj)

%Yf=obj.hank(obj.c*obj.l+1:2*obj.c*obj.l,:);
%W1=(Yf*Yf')^(-0.5);

Yp=obj.hank(1:obj.c*obj.l,:);
Yf=obj.hank(obj.c*obj.l+1:2*obj.c*obj.l,:);

obj.hank=[];    %清空hankel矩阵（可选）

Tplz=Yf*Yp';    %托普利兹矩阵

[obj.U,obj.S,obj.V]=svd(Tplz);         %%%%%奇异值分解

%n=rank(S);               %%%%理论上是按照此条命令，根据奇异值矩阵S的对角线非零元素个数确定系统阶数，但是由于噪声的影响，奇异值矩阵的对角线元素是不断减小的，
%后面的接近0，实际上是认为奇异值很小时就当作0考虑。
%bar(diag(S));
end
