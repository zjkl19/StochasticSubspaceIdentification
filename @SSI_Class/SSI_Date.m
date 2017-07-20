
%类方法名:SSI_Date
%类功能:基于数据驱动的随机子空间方法
%传入参数:obj
%返回参数:obj

function obj=SSI_Date(obj)

%Yf=obj.hank(obj.c*obj.l+1:2*obj.c*obj.l,:);
%W1=(Yf*Yf')^(-0.5);

[Q,R]=qr(obj.hank');

obj.hank=[];    %清空hankel矩阵（可选）

Q=Q'; R=R';
R21=R(obj.l*obj.c+1:end,1:obj.l*obj.c);
Q1=Q(1:obj.l*obj.c,:);
PP=R21*Q1;                %将来行空间到过去行空间的投影——林迪南注

%PP=W1*PP;                %%%%%CAV加权法

[obj.U,obj.S,obj.V]=svd(PP);         %%%%%奇异值分解
%n=rank(S);               %%%%理论上是按照此条命令，根据奇异值矩阵S的对角线非零元素个数确定系统阶数，但是由于噪声的影响，奇异值矩阵的对角线元素是不断减小的，
%后面的接近0，实际上是认为奇异值很小时就当作0考虑。
%bar(diag(S));
end
