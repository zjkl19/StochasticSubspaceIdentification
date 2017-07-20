%函数名:SSICluster
%函数功能:对稳定图的极点进行聚类，从而实现各阶频率的自动计算
%传入参数:
%返回参数:
function SSICluster(obj,ViewObj)

tic;    %计时开始
disp('开始计算，正在计算中……');

yearFolderName='20x';   %20xx年 文件夹名称

DayFolder=dir([pwd '\' yearFolderName]);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）
chn=[6	12	15	22	31	38	96	103	143	150	155];   %灌河大桥的竖向通道

for loopi=1:days
    MatFiles=dir([pwd '\' yearFolderName '\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
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
        
        %--------------此步为可选步骤---------------------
        optimal=1;  %optimal==1 表示选中
        if optimal==1
            figure;
            loc=find(ViewObj.MPView.PlotRange==':');
            PR(1)=str2double(ViewObj.MPView.PlotRange(1:loc-1));
            PR(2)=str2double(ViewObj.MPView.PlotRange(loc+1:end));
            obj.SSIObj=obj.SSIObj.StablePlot(PR);
        end
        %-----------------------------------
                obj.SSIObj = obj.SSIObj.getStatusOfPoles;
        
        obj.SSIObj.SSIRegM(obj.SSIObj.M_zx);      %将稳定图中的所有振型标准化（第1个测点归一化）
        %注意,SSI_Class的PlotMode方法
        
        [WD,WD_DR,WD_Mode,~,~,~,~ ] = obj.SSIObj.getStablePoles;
        
        WD_dist=pdist(WD(:,1));
        
        %blks=97;
        %plotFitPDF(WD_dist,blks);
        
        %展示pdist原理的代码：
        %WDsize=size(WD(:,1),1);
        %WD_dist01=zeros(1,WDsize*(WDsize-1)/2);
        %k=1;
        %wWD1=0.7;wWD2=0.3;
        %for i=1:(WDsize-1)
        %    for j=(i+1):WDsize
        %        MACij=getMAC(WD_Mode(:,i),WD_Mode(:,j));
        %        WD_dist01(k)=wWD1*abs(WD(i,1)-WD(j,1))/abs(max(WD(i,1),WD(j,1)))*wWD2*(1-MACij);
        %        k=k+1;
        %    end
        %end
        
        %WD_dist=WD_dist01;
        
        % distfun = @(XI,XJ)((bsxfun(@minus,1,XJ/XI)));
        %Dwgt = pdist(X, @(Xi,Xj) distfun(Xi,Xj,Wgts));
        
        %WD_dist=pdist(WD(:,1),@(Xi,Xj) distfun(Xi,Xj));   %稳定点之间的“距离”
        
        %定义频率为距离
        
        % 新建图形窗口，然后绘制频率直方图，直方图对应97个小区间
        %figure;
        %[f_ecdf, xc] = ecdf(WD_dist);
        %ecdfhist(f_ecdf, xc, 97);
        %hold on;
        %xlabel('x');  % 为X轴加标签
        %ylabel('f(x)');  % 为Y轴加标签
        
        % 调用ksdensity函数进行核密度估计
        [f_ks1,xi1,~] = ksdensity(WD_dist,'support','positive');
        
        % 绘制核密度估计图，并设置线条为黑色实线，线宽为3
        %plot(xi1,f_ks1,'r','linewidth',2)
        
        [maxPks,maxLocs]=findpeaks(f_ks1);     %查找极大值
        %hold on
        %plot(xi1(maxLocs),maxPks,'ro')
        [minPks,minLocs]=findpeaks(-f_ks1);    %查找极小值
        %hold on
        %plot(xi1(minLocs),-minPks,'ro');
        
        %squareform(WD_dist)            %查看“距离矩阵”
        LinkWD = linkage(WD_dist);      %联结稳定点
        c = cophenet(LinkWD,WD_dist);   %查看聚类效果
        
        %figure;
        %[H,T] =dendrogram(LinkWD,'colorthreshold','default');      %查看谱系图
        
        T = cluster(LinkWD,'cutoff',0.5*xi1(min(minLocs)),'criterion','distance');
        %T = cluster(LinkWD,'cutoff',0.6,'depth',1.1);
        maxC=max(T);    %最大聚类数
        f=zeros(1,maxC);
        dp=zeros(1,maxC);
        mmode=zeros(size(WD_Mode(:,1),1),maxC);
        
        totalC=1;   %总的聚类数
        
        %二次聚类
        for i=1:maxC
            posLanda=(find(T==i)); %定位向量
            
            if size(posLanda,1)<=2  %小于2个元素的情况认为是虚假模态，不予考虑
                continue;
            end
            
            WDsize=size(WD(posLanda,1),1);
            WD_dist=zeros(1,WDsize*(WDsize-1)/2);
            k=1;
            
            for ii=1:(WDsize-1)
                for jj=(ii+1):WDsize
                    MACij=getMAC(WD_Mode(:,ii),WD_Mode(:,jj));
                    WD_dist(k)=(1-MACij);
                    k=k+1;
                end
            end
            
            
            %squareform(WD_dist)            %查看“距离矩阵”
            LinkWD = linkage(WD_dist);      %联结稳定点
            c = cophenet(LinkWD,WD_dist);   %查看聚类效果
            
            %figure;
            %[H_in,T_in] =dendrogram(LinkWD,'colorthreshold','default');      %查看谱系图
            
            %T_in = cluster(LinkWD,'cutoff',0.5*(max(WD_dist)+min(WD_dist)),'criterion','distance');
            T_in = cluster(LinkWD,'cutoff',0.1,'criterion','distance');
            %T = cluster(LinkWD,'cutoff',0.6,'depth',1.1);
            maxC_in=max(T_in);    %最大聚类数
            %f_in=zeros(1,maxC_in);
            %dp_in=zeros(1,maxC_in);
            %mmode_in=zeros(size(WD_Mode(:,1),1),maxC_in);
            
            tempWD=WD(posLanda,1);
            tempWD_DR=WD_DR(posLanda);
            tempWD_Mode=WD_Mode(:,posLanda);
            for m=1:maxC_in
                posLandaIn=(find(T_in==m)); %定位向量
                
                if size(posLandaIn,1)<=2  %小于2个元素的情况认为是虚假模态，不予考虑
                    continue;
                end
                
                f(totalC)=mean(tempWD(posLandaIn,1));
                dp(totalC)=mean(tempWD_DR(posLandaIn));
                mmode(:,totalC)=mean(tempWD_Mode(:,posLandaIn),2);
                totalC=totalC+1;
            end
            %f(i)=mean(WD(posLanda,1));
            %dp(i)=mean(WD_DR(posLanda));
            %mmode(:,i)=mean(WD_Mode(:,posLanda),2);    %变量名实际上应为mode,为了避免变量名冲突,取mmode
        end
        
        v1Mode=[0.000E+00	-7.486E-04	-1.856E-01	0.000E+00	4.343E-01	9.938E-01	4.343E-01	0.000E+00	-1.858E-01	0.000E+00	0.000E+00];
        v2Mode=[0.000E+00	-2.475E-04	2.945E-01	0.000E+00	-8.039E-01	1.932E-05	8.039E-01	0.000E+00	-2.947E-01	0.000E+00	0.000E+00];
        
        v1Landa=1;
        
        maxV1MAC=0;
        
        for i=1:maxC     %匹配振型
            MACget=getMAC(mmode(:,i),v2Mode);
            if MACget>maxV1MAC
                maxV1MAC=MACget;
                v1Landa=i;
            end
        end
        
        disp(['竖向1阶，频率：' num2str(f(v1Landa))]);
        disp('竖向1阶，振型：');
        disp(mmode(:,v1Landa));
        
        [f_sort f_landa]=sort(f);     %将频率从小到大排列
        dp_sort=dp(f_landa);          %将阻尼比对应进行排列
        mmode_sort=mmode(:,f_landa);  %将振型对应进行排列
        save('ghfreq.txt', 'f_sort','-ASCII','-append');
    end
end

disp('计算完成!');
toc;    %计时结束
end