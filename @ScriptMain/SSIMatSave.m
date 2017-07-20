%函数名:SSIMatSave
%函数功能:储存基于SSI法生成的mat文件
%传入参数:
%返回参数:
function SSIMatSave(obj,ViewObj)

tic;    %计时开始
disp('开始转存Mat文件，请等待……');

yearFolderName='20x';   %20xx年 文件夹名称
sYearFolderName='20y';  %存储SSImat: 20xx年 文件夹名称

DayFolder=dir([pwd '\' yearFolderName]);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）
chn=[6	12	15	22	31	38	96	103	143	150	155];   %竖向通道

nMats=0;    %mat文件的总个数
for loopi=1:days
    MatFiles=dir([pwd '\' yearFolderName '\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nMats=nMats+(numel(MatFiles)-2);
end

cMat=1;     %当前的mat文件，统计进度用
for loopi=1:days
    MatFiles=dir([pwd '\' yearFolderName '\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
    
    if ~exist([pwd '\' sYearFolderName '\' DayFolder(loopi+2).name],'dir')
        mkdir([pwd '\' sYearFolderName '\' DayFolder(loopi+2).name]);
    end
    
    for loopj=1:nm
        load([pwd '\' yearFolderName '\' DayFolder(loopi+2).name '\' MatFiles(loopj+2).name]);
        if exist('data','var')
            RawData=data(:,chn);
        else
            RawData=Data0(:,chn);
        end
        %RawData=load(ViewObj.MPView.PathInfo); %读取原始数据
        
        n=10;   %压缩参数
        
        %------对原始数据进行滤波----
        OriginalDate=RawData;                       %读取原始数据
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
        %----------------------------
        RawData=FinalDate;
        
        obj.SSIObj=SSI_Class('SSIConfigFile.txt',RawData);     %类实例化
        obj.SSIObj=obj.SSIObj.getHankel;
        
        obj.SSIObj.methodID=1;      %1:SSI_Cov 2:SSI_Date       
        obj.SSIObj=obj.SSIObj.SSIgetUSV;       
 
        obj.SSIObj=obj.SSIObj.SSITable(obj.SSIObj.NN);
       
        obj.SSIObj = obj.SSIObj.getStatusOfPoles;
        
        obj.SSIObj.SSIRegM(obj.SSIObj.M_zx);      %将稳定图中的所有振型标准化（第1个测点归一化）
        %注意,SSI_Class的PlotMode方法
        
        [WD,WD_DR,WD_Mode,~,~,~,~ ] = obj.SSIObj.getStablePoles;
        
        save([pwd '\' sYearFolderName '\' DayFolder(loopi+2).name '\SSI' MatFiles(loopj+2).name], 'WD', 'WD_DR','WD_Mode');
        fprintf('当前文件:%s ',MatFiles(loopj+2).name);
        fprintf('当前进度:%%%4.1f\n',cMat*100/nMats);
        toc;
        cMat=cMat+1;
    end
end

disp('转存完成!');
toc;    %计时结束
end