%类名称:SSI_Class
%类功能:调用这个类，可以实现对时域信号的模态识别
%构造函数说明:
%nargin==0:相关参数自己在程序中改
%nargin==2:相关参数通过配置文件读取（推荐）
%ConfigFile：有关的配置文件
%RawData:原始数据，要求原始数据为列向量，每1列数据为1个通道的时程数据，数据不含表头

%返回参数:

classdef SSI_Class<handle
    properties(Access=public)
        SF   %采样频率
        TData   %原始时域数字信号,l个通道数据（每一列代表1个通道的数据）
        c=15;                  %%%%%c==i;定义的块行数＝2*c
        NN=10*2;              %计算的投影矩阵最大阶数NN，稳定图系统最大阶数NN
        II=[0.05 0.05 0.05]; %指标阈值矩阵 （特征频率，阻尼比，模态振型，一般取1%,5%,2%）
        
        l        %测点通道数
        n         %此处n即论文中的s，数据长度
        
        hank    %Hankel矩阵（此处变量名不使用hankel，防止与matlab自带函数hankel冲突）
        
        methodID=1      %采用何种方法？
                        %ID==1:采用SSI_Cov
                        %ID==2:采用SSI_Date
                        %其它:error
                        
        considerMSI=1   %是否考虑模态相似指数（详见章国稳论文）
                        %considerMSI==1 表示考虑
                        %considerMSI==0 表示不考虑
                        
        MSI             %模态相似指数     
        MSItor=1        %指标MSI的容差
        
        considerEP=0    %是否考虑模态能量
                        %详见论文“基于谱系聚类的随机子空间模态参数自动识别”——章国稳 论文中 模态能量部分
                        %considerEP==0 表示不考虑
        
        U
        S
        V      %U、S、V，奇异值分解的结果
       
        eP     %模态能量P
        
        freq	%频率
        damp    %阻尼比
        modal   %模态
        w       %假定某阶系统，计算的特征频率
        z       %假定某阶系统，计算的特征频率
        cm      %假定某阶系统，计算的特征频率
        
        M_pl         %M_pl(i,j)按列向量储存各阶频率,即第j列表示第j阶模态的j个频率, M_pl(i,j)表示第j阶系统，第i个频率值
        M_znb        %M_znb(i,j)按列向量储存各阶模态,即第j列表示第j阶模态的j个阻尼比
        M_zx        %M_zx(:,j,k) 振型为列向量，表示k阶系统，第j个模态振型
        
        M_eP        %M_eP(i,j)按列向量储存各阶模态能量,即第j列表示第j阶模态的j个能量, M_eP(i,j)表示第j阶系统，第i个模态对应的能量值
        
        
        cmp_M_pl      %应用论文"基于谱系聚类的随机子空间模态参数自动识别 —— 章国稳" 的状态矩阵A 新的估计方式算得的M_pl
        cmp_M_znb
        cmp_M_zx
        
        %"完整版"数据矩阵
        %M_pl储存的有效数据是M_freq的一半，因为有一对共轭特征值的缘故
        M_freq
        M_damp
        M_mshape
        M_landa
        
        cmp_M_freq
        cmp_M_damp
        cmp_M_mshape
        cmp_M_landa
        
        M_Rshape	%储存实振型
        %M_Rshape(:,j,k) 表示第k阶系统，第j个模态振型
        %M_Rshape=zeros(obj.l,obj.NN/2,obj.NN/2);
        
        RegShape   %标准化后的振型
        
        Indicator    %obj.Indicator(i,j,k)指标矩阵，表示第k阶系统，第i阶模态的3个指标（特征频率，阻尼比，模态振型）
        
        WD       %WD(i,1):第i个稳定点频率；WD(i,2)：第i个稳定点所处的系统阶数
        WD_DR    %Damp Ratio, 阻尼比，WD_DR(i)：第i个稳定点的阻尼比
        WD_Mode  %WD_Mode(:,i):第i个稳定点的振型
        
    end
    
    methods(Access=public)
        function obj=SSI_Class(ConfigFile,RawData)     %构造函数
            if nargin==0            %相关参数直接在程序中修改
                load('Y.txt');
                obj.TData=Y;
                obj.SF=50;
                obj.n=size(obj.TData,1);
                obj.l=size(obj.TData,2);
                
            elseif nargin==2
                ConfigData=load(ConfigFile);   %相关参数从配置文件中读取
                obj.TData=RawData;
                obj.SF=ConfigData(1);
                obj.c=ConfigData(2,1);
                obj.NN=ConfigData(3,1);
                obj.II(1)=ConfigData(4,1);
                obj.II(2)=ConfigData(5,1);
                obj.II(3)=ConfigData(6,1);
                
                %无需从配置文件读取，自动计算
                obj.n=size(obj.TData,1);
                obj.l=size(obj.TData,2);
            else
                error('wrong input arguments');
            end
        end
        
        %函数名:obj=SSICore(obj)
        %函数功能:利用稳定图法进行计算
        %传入参数:obj   N:最大计算系统阶数
        %返回参数:obj
        function obj=SSICore(obj)
            %obj=obj.PPsvd;
            obj=obj.getHankel;
            
            if obj.methodID==1
                obj=SSI_Cov(obj);
            elseif obj.methodID==2
                obj=SSI_Date(obj);
            else
                error('Error method ID.');
            end
            
            obj=obj.SSITable(obj.NN);
            obj=StablePlot(obj,PR);
            
            %obj=ExtractRshape(obj);
            %obj.M_zx=obj.M_Rshape;
            %obj=obj.SSIRegM(obj.M_zx);
            
            %obj=StablePlot(obj,PR);
            
            %obj=obj.SSIRegM;
            
        end
        
        %matlab规定：类定义中必须包括方法的声明
        
        %obj=PPsvd(obj); %matlab规定，放在外部文件的成员方法声明不需要function关键词
        
        obj=getHankel(obj);
        
        obj=SSI_Cov(obj);
        
        obj=SSI_Date(obj);
        
        obj=SSIgetUSV(obj);
 
        varargout=CalcModal(obj,n);
        [w,z,cm,freq,damp,mshape,landa]=cmp_CalcModal(obj,n);
        
        obj=getStatusOfPoles(obj);
        
        obj=SSITable(obj,NN);
       
        obj=StablePlot(obj,PR);
        
        %[WD,WD_DR,WD_Mode,WD_plzx,WD_plznb,WD_pl,other_pole ]=getStablePoles(obj);
        [WD,WD_DR,WD_Mode,WD_plzx,WD_plznb,WD_pl,other_pole ]=getStablePoles(obj);
        
        obj=SSIRegM(obj,ThisShape);
       
        bj=ExtractRshape(obj);
       
        obj=SSIPost(varargin);
        
        IDmodOrder(obj,n,f);
        
 
    end
  
end