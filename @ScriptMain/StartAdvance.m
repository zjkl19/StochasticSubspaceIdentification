%开始运行高级功能
function StartAdvance(obj,ViewObj)

tic;    %计时开始
disp('开始计算，正在计算中……');
DayFolder=dir([pwd '\20x']);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）
chn=[6	12	15	22	31	38	96	103	143	150	155];

for loopi=1:days
    MatFiles=dir([pwd '\20x\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
    for loopj=1:nm
        load([pwd '\20x\' DayFolder(loopi+2).name '\' MatFiles(loopj+2).name]);
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
        obj.SSIObj=obj.SSIObj.PPsvd;
        obj.SSIObj=obj.SSIObj.SSITable(obj.SSIObj.NN);
        
        %--------------此步为可选步骤---------------------
        %figure(2);
        %loc=find(ViewObj.MPView.PlotRange==':');
        %PR(1)=str2double(ViewObj.MPView.PlotRange(1:loc-1));
        %PR(2)=str2double(ViewObj.MPView.PlotRange(loc+1:end));
        %obj.SSIObj=obj.SSIObj.StablePlot(PR);
        %-----------------------------------
        
        I=obj.SSIObj.II;
        BigNum=1000;    %BigNum简单地讲就是为了数据处理的方便
        %后面有个阈值识别矩阵，后面稳定点识别的阈值都很小
        %如果预定义一个大值，就是默认该点不是稳定点
        obj.SSIObj.Indicator=ones(obj.SSIObj.NN/2,3,obj.SSIObj.NN/2);   %obj.Indicator(i,j,k)指标矩阵，表示第k阶系统，第i阶模态的3个指标（特征频率，阻尼比，模态振型）
        obj.SSIObj.Indicator=BigNum*obj.SSIObj.Indicator;       %乘1个大数
        
        for i=2:obj.SSIObj.NN/2        %遍历各阶系统
            for j=1:(i-1)       %遍历系统中各阶模态
                obj.SSIObj.Indicator(j,1,i)=(obj.SSIObj.M_pl(j,i)-obj.SSIObj.M_pl(j,i-1))/obj.SSIObj.M_pl(j,i-1);
                obj.SSIObj.Indicator(j,1,i)=abs(obj.SSIObj.Indicator(j,1,i));
                
                obj.SSIObj.Indicator(j,2,i)=(obj.SSIObj.M_znb(j,i)-obj.SSIObj.M_znb(j,i-1))/obj.SSIObj.M_znb(j,i-1);
                obj.SSIObj.Indicator(j,2,i)=abs(obj.SSIObj.Indicator(j,2,i));
                
                obj.SSIObj.Indicator(j,3,i)=(obj.SSIObj.M_zx(:,j,i)'*obj.SSIObj.M_zx(:,j,i-1))^2/ (obj.SSIObj.M_zx(:,j,i)'*obj.SSIObj.M_zx(:,j,i) * obj.SSIObj.M_zx(:,j,i-1)'*obj.SSIObj.M_zx(:,j,i-1)) ;
                obj.SSIObj.Indicator(j,3,i)=abs(obj.SSIObj.Indicator(j,3,i));
                obj.SSIObj.Indicator(j,3,i)=abs(1-obj.SSIObj.Indicator(j,3,i));
            end
        end
        
        %绘制稳定图
        nwd=0;          %稳定点个数初始化
        nwd_plzx=0;     %频率和振型稳定
        nwd_plznb=0;    %频率和阻尼比稳定
        nwd_pl=0;       %只有频率稳定
        n_other=0;   %除以上点之外的其他点
        
        %实际上，XY最后的行数=0.5*(NN/2+1)*NN/2)，等差数列求和
        
        for i=1:obj.SSIObj.NN/2    %所有点（包括非稳定点）
            %遍历各阶系统
            for j=1:i  %读取第i阶系统第j个频率(从小到大)
                %第1列是模态频率，第2列是模态阶数
                
                if (obj.SSIObj.Indicator(j,1,i)<I(1) && obj.SSIObj.Indicator(j,2,i)<I(2) && obj.SSIObj.Indicator(j,3,i)<I(3))
                    nwd=nwd+1;              %稳定点个数
                    WD(nwd,1)=obj.SSIObj.M_pl(j,i);
                    WD(nwd,2)=i;
                elseif (obj.SSIObj.Indicator(j,1,i)<I(1) && obj.SSIObj.Indicator(j,2,i)>=I(2) && obj.SSIObj.Indicator(j,3,i)<I(3))
                    nwd_plzx=nwd_plzx+1;    %频率和振型
                    WD_plzx(nwd_plzx,1)=obj.SSIObj.M_pl(j,i);
                    WD_plzx(nwd_plzx,2)=i;
                elseif (obj.SSIObj.Indicator(j,1,i)<I(1) && obj.SSIObj.Indicator(j,2,i)<I(2) && obj.SSIObj.Indicator(j,3,i)>=I(3))
                    nwd_plznb=nwd_plznb+1;  %频率和阻尼比
                    WD_plznb(nwd_plznb,1)=obj.SSIObj.M_pl(j,i);
                    WD_plznb(nwd_plznb,2)=i;
                elseif (obj.SSIObj.Indicator(j,1,i)<I(1) && obj.SSIObj.Indicator(j,2,i)>=I(2) && obj.SSIObj.Indicator(j,3,i)>=I(3))
                    nwd_pl=nwd_pl+1;        %仅频率
                    WD_pl(nwd_pl,1)=obj.SSIObj.M_pl(j,i);
                    WD_pl(nwd_pl,2)=i;
                else
                    n_other=n_other+1;
                    other_pole(n_other,1)=obj.SSIObj.M_pl(j,i);
                    other_pole(n_other,2)=i;
                end
            end
        end
        v1bound=[0.365 0.395];  %灌河大桥竖向1阶频率上下界
        sum=0;
        np=0;   %结点数==0
        for i=1:nwd
            if WD(i,1)>v1bound(1) && WD(i,1)<v1bound(2)
                sum=sum+WD(i,1);
                np=np+1;
            end
        end
        f=sum/np;   %求均值
        save('ghfreq.txt', 'f','-ASCII','-append');
    end
end
  
    disp('计算完成!');
    toc;    %计时结束
end