%函数名:Custom
%函数功能:订制功能,一般为作者使用
%传入参数:
%返回参数:
function Custom(obj,ViewObj)

tic;    %计时开始

minElems=3;     %单个Cluster最少需要的元素
MACcut=0.1;     %第二次聚类的cut阈值

sYearFolderName='20y';  %存储SSImat: 20xx年 文件夹名称
                 
disp('正在对稳定点进行聚类分析，分析中……');
DayFolder=dir([pwd '\' sYearFolderName]);     %某月每日对应文件夹
days=size(DayFolder,1)-2;   %天数，（扣除 . 和 .. 文件夹）

firstWrite=1;   %是否为第1次写入

for loopi=1:days
    MatFiles=dir([pwd '\' sYearFolderName '\' DayFolder(loopi+2).name]);    %某月某日文件夹下对应的所有mat文件
    nm=size(MatFiles,1)-2;  %mat文件个数（扣除 . 和 ..)
    for loopj=1:nm
        load([pwd '\' sYearFolderName '\' DayFolder(loopi+2).name '\' MatFiles(loopj+2).name]);
        if ~exist('WD','var')
            warning('There is no var ''WD''. ');
        end
        %RawData=load(ViewObj.MPView.PathInfo); %读取原始数据        
        
        %利用基于索引的异类挖掘剔除异常数据
        %《数据挖掘》第二版 朱明 P258
        [WD,WD_DR,WD_Mode]=rmAbnormWD(WD,WD_DR,WD_Mode);
        
        WD_dist=pdist(WD(:,1));     %从load的文件中，可以读出变量WD
        
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
        %c = cophenet(LinkWD,WD_dist)   %查看聚类效果
        
        %figure;
        %[H,T] =dendrogram(LinkWD,'colorthreshold','default');      %查看谱系图
        
        %T = cluster(LinkWD,'cutoff',0.11,'criterion','distance');
        T = cluster(LinkWD,'cutoff',0.3*xi1(min(minLocs)),'criterion','distance');
        
        %cutDepth=xi1(min(minLocs));
        %save('firstCutDist.txt', 'cutDepth','-ASCII','-append');   %第一次cut的depth
        
        %T = cluster(LinkWD,'cutoff',0.6,'depth',1.1);
        maxC=max(T);    %最大聚类数
        f=zeros(1,maxC);
        dp=zeros(1,maxC);
        mmode=zeros(size(WD_Mode(:,1),1),maxC);
        
        totalC=1;   %总的聚类数
        
        %二次聚类
        for i=1:maxC
            posLanda=(find(T==i)); %定位向量
            
            if size(posLanda,1)<minElems  %小于等于2个元素的情况认为是虚假模态，不予考虑
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
            %c = cophenet(LinkWD,WD_dist)   %查看聚类效果
            
            %figure;
            %[H_in,T_in] =dendrogram(LinkWD,'colorthreshold','default');      %查看谱系图
            
            %T_in = cluster(LinkWD,'cutoff',0.5*(max(WD_dist)+min(WD_dist)),'criterion','distance');
            T_in = cluster(LinkWD,'cutoff',MACcut,'criterion','distance');
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
                
                if size(posLandaIn,1)<minElems  %小于minElems个元素的情况认为是虚假模态，不予考虑
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
        [iFreq,~,~]=identifyMode(f,dp,mmode);  
        
        if firstWrite==1
            save([DayFolder(3).name(1:6) 'ghfreq.txt'], 'iFreq','-ASCII');
            firstWrite=0;
        else
            save([DayFolder(3).name(1:6) 'ghfreq.txt'], 'iFreq','-ASCII','-append');
        end
        
    end
end

disp('分析完成!');
toc;    %计时结束
end