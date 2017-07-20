%clear;clc;
tic;

fNameFolder='20y';      %储存文件名的文件夹
saveName='sFileName.txt';   %写入文件名的txt
disp('正在写入……');
DayFolder=dir([pwd '\' fNameFolder]);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）

fid=fopen(saveName,'w');

for loopi=1:days
    MatFiles=dir([pwd '\' fNameFolder '\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
    for loopj=1:nm
        fprintf(fid,'%s\n',MatFiles(loopj+2).name);
    end
end

fclose(fid);
disp('已经写入！');

toc;

