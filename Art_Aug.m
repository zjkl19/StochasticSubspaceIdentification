%自动生成列表文件
DayFolder=dir([pwd '\20x']);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）

listall=[];

for loopi=1:days   
    MatFiles=dir([pwd '\20x\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
    list=cell(nm,2);
    list{1,1}=DayFolder(loopi+2).name;
    for loopj=1:nm
        list{loopj,2}=loopj;
    end
    listall=[listall;list];
end