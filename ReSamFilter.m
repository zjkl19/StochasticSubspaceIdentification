%函数名:ReSamFilter
%函数功能:对输入数据调用decimate函数进行滤波和重采样
%传入参数：InputFile:原始数据所在文件，每1列代表1个通道的数据
%OutputFile:输出文件，每1列对应原始数据处理后的结果
%n:压缩率
%返回参数：无
function ReSamFilter(InputFile,OutputFile,n)
tic
OriginalDate=load(InputFile);                       %读取原始数据
RowNum=size(OriginalDate,1);                      %读取行数
CloumnNum=size(OriginalDate,2);                   %读取列数
if (mod(RowNum,n)==0)
    FinalDate=zeros(RowNum/n,CloumnNum);
else
    FinalDate=zeros(fix(RowNum/n)+1,CloumnNum);
end
for i=1:CloumnNum
    Transition=OriginalDate(:,i);                 %提取一列
    Transition=decimate(Transition,n);            %滤波
    FinalDate(:,i)=Transition;                    %加入新矩阵
end
save(OutputFile,'FinalDate','-ASCII')                     %输出文件
toc
disp(['输出压缩率为' num2str(n) '的输出文件为' OutputFile])

