%函数名:cmp_CalcModal(obj,n)
%函数功能:根据假定的系统自由度个数，计算系统的模态
%其中状态矩阵A采用新的估计方式，新的估计方式见论文"基于谱系聚类的随机子空间模态参数自动识别——章国稳"
%传入参数:obj：对象;n:假定的投影矩阵阶数
%返回参数:freq，damp,mshape:在系统为n/2阶的情况下，计算出来的结构模态
%备注：函数名中的cmp表示CoMPare
function [w z cm freq damp mshape landa]=cmpCalcModal(obj,n)

U1=obj.U(:,1:n);
S1=obj.S(1:n,1:n);
Oi=U1*(S1^0.5);             %Oi=U1*S1^0.5*T
%相似变换简单取T=E
%可观矩阵Oi，林迪南注
A1=Oi(1:(obj.c-1)*obj.l,:);           %Oi去掉最后l行
A2=Oi(obj.l+1:obj.c*obj.l,:);           %Oi去掉前l行

A=(A2'*A1)^-1*A2'*A2;        %与CalcModal函数相比，仅此行代码不同
%A:离散状态矩阵

C=Oi(1:obj.l,:);

%理论，文献[1] P36
%[psi,L]=eig(A);     %psi:特征向量 D:特征值
%参考macec2.0 modpar.m文件
%modpar(A,C,dt)
%(cm, mode shape [-]; w, eigenfrequencies [Hz]; z, damping ratios [%])

dt=obj.SF^-1;

[psi,L] = eig(A);
landa=diag(L);  %结果为列向量
s = log(diag(L))/dt;
[w,I] = sort(abs(s));

freq= 1/(2*pi)*w;
damp = -100*cos(atan2(imag(s),real(s)));   %阻尼比
mshape = C*psi(:,I);     %模态

s = s(I(1:2:end));
w = 1/(2*pi)*w(1:2:end);     %特征频率
z = -100*cos(atan2(imag(s),real(s)));   %阻尼比
cm = C*psi(:,I(1:2:end));     %模态

end
