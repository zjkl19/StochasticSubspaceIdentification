%函数名：CreateModFile
%函数功能：建立mod文件
%传入参数：FileName:输出文件名,类型：字符
%n：模态阶数
%返回参数：无

function CreateModFile(FileName,n)

load('ldn_matrix.mat');
l=size(M_zx,1);     %获取通道数

result=zeros(2+l,2*n+1);     %建立[(2+l)*(2*n+1)]阶矩阵result

result(3:2+l,1)=(1:l)';      %将通道编号1~l写入矩阵result

result(1,2:2:2*n)=M_pl(1:n,n);     %将各阶模态的频率写入矩阵result
result(2,2:2:2*n)=M_znb(1:n,n);    %将各阶模态的阻尼比写入矩阵result

result(3:l+2,2:2:2*n)=real(M_zx(1:l,1:n,n));    %将各通道各阶模态的振型的实部写入矩阵result
result(3:l+2,3:2:2*n+1)=imag(M_zx(1:l,1:n,n));    %将各通道各阶模态的振型的虚部写入矩阵result

save(FileName,'result','-ASCII');               %将矩阵result写入文件File

end















