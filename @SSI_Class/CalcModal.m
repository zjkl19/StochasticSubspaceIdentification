%函数名:CalcModal(obj,n)
%函数功能:根据假定的系统自由度个数，计算系统的模态
%传入参数:obj：对象;n:假定的投影矩阵阶数
%返回参数:freq，damp,mshape:在系统为n/2阶的情况下，计算出来的结构模态
function varargout=CalcModal(obj,n)

U1=obj.U(:,1:n);
S1=obj.S(1:n,1:n);

Oi=U1*(S1^0.5);             %Oi=U1*S1^0.5*T
%相似变换简单取T=E
%可观矩阵Oi，林迪南注
A1=Oi(1:(obj.c-1)*obj.l,:);           %Oi去掉最后l行
A2=Oi(obj.l+1:obj.c*obj.l,:);           %Oi去掉前l行

A=(pinv(A1))*A2;
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

varargout{1}=w;varargout{2}=z;varargout{3}=cm;
varargout{4}=freq;varargout{5}=damp;varargout{6}=mshape;varargout{7}=landa;

if obj.considerEP==1
    
    V1=obj.V(1:n,:);    %新添加的部分，若不计算模态能量，可不管此处
    deltaM1=(S1^0.5)*V1;    %新添加的部分，若不计算模态能量，可不管此处
    %可控矩阵
    G=deltaM1(:,(obj.c-1)*obj.l+1:obj.c*obj.l);     %状态-输出矩阵
    
    eP=zeros(n/2,1);     %模态能量
    for i=1:n/2
        psiInv=psi^-1;
        M=C*psi(:,i)*psiInv(i,:)*G;    %新添加的部分，若不计算模态能量，可不管此处
        %详见章国稳小论文—基于谱系聚类的随机子空间模态参数自动识别
        eP(i)=2*(real(diag(M).'*diag(M)*(1-(landa(i))^2)^-1)+abs(diag(M).'*diag(M)*(1-abs(landa(i))^2)^-1))*dt;
        
        eP(i)=10*log10(eP(i));  %将功率单位W转换为分贝
    end
    
    ePI=I(1:2:end);     %ePI为列向量
    for i=1:size(ePI,1)
        if mod(ePI(i,1),2)==0   %若为偶数
            ePI(i,1)=ePI(i,1)/2;
        else
            ePI(i,1)=(ePI(i,1)+1)/2;
        end
    end
    
    eP=eP(ePI);    %模态能量
    varargout{8}=eP;

end

end
