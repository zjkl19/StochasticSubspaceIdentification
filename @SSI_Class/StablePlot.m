%类方法名:StablePlot(obj)
%类方法功能:根据已经计算得出的各阶系统模态，绘制稳定图
%传入参数:obj,varargin
%varargin{1}(1),varargin{1}(2)分别表示plot出来的稳定图中x轴的上界和下界
%返回参数:obj
function obj=StablePlot(obj,varargin)
I=obj.II;

obj = obj.getStatusOfPoles;

%绘制稳定图
nwd=0;          %稳定点个数初始化
nwd_plzx=0;     %频率和振型稳定
nwd_plznb=0;    %频率和阻尼比稳定
nwd_pl=0;       %只有频率稳定
n_other=0;   %除以上点之外的其他点

%实际上，XY最后的行数=0.5*(NN/2+1)*NN/2)，等差数列求和

%obj.considerMSI=0;

for i=1:obj.NN/2    %所有点（包括非稳定点）
    %遍历各阶系统
    for j=1:i  %读取第i阶系统第j个频率(从小到大)
        %第1列是模态频率，第2列是模态阶数
        if obj.considerMSI==1
            if obj.MSI(i,j)>obj.MSItor
                continue;
            end
        end
        if (obj.Indicator(j,1,i)<I(1) && obj.Indicator(j,2,i)<I(2) && obj.Indicator(j,3,i)<I(3))
            nwd=nwd+1;              %稳定点个数
            WD(nwd,1)=obj.M_pl(j,i);
            WD(nwd,2)=i;
        elseif (obj.Indicator(j,1,i)<I(1) && obj.Indicator(j,2,i)>=I(2) && obj.Indicator(j,3,i)<I(3))
            nwd_plzx=nwd_plzx+1;    %频率和振型
            WD_plzx(nwd_plzx,1)=obj.M_pl(j,i);
            WD_plzx(nwd_plzx,2)=i;
        elseif (obj.Indicator(j,1,i)<I(1) && obj.Indicator(j,2,i)<I(2) && obj.Indicator(j,3,i)>=I(3))
            nwd_plznb=nwd_plznb+1;  %频率和阻尼比
            WD_plznb(nwd_plznb,1)=obj.M_pl(j,i);
            WD_plznb(nwd_plznb,2)=i;
        elseif (obj.Indicator(j,1,i)<I(1) && obj.Indicator(j,2,i)>=I(2) && obj.Indicator(j,3,i)>=I(3))
            nwd_pl=nwd_pl+1;        %仅频率
            WD_pl(nwd_pl,1)=obj.M_pl(j,i);
            WD_pl(nwd_pl,2)=i;
        else
            n_other=n_other+1;
            other_pole(n_other,1)=obj.M_pl(j,i);
            other_pole(n_other,2)=i;
        end
    end
end

WD_DR=zeros(1,nwd);WD_Mode=zeros(11,nwd);
[WD,WD_DR,WD_Mode]=rmAbnormWD(WD,WD_DR,WD_Mode); %



hold on;

if nwd~=0
    scatter(WD(:,1),WD(:,2),'ko');
    %scatter(WD(:,1),WD(:,2),'+');
end

pSwitch=0;  %是否在稳定图中绘出其它点

if pSwitch~=0
    
    if nwd_plzx~=0
        scatter(WD_plzx(:,1),WD_plzx(:,2),'kx');        %最好把颜色属性设置为默认值
    end
    if nwd_plznb~=0
        scatter(WD_plznb(:,1),WD_plznb(:,2),'k*');
    end
    if nwd_pl~=0
        scatter(WD_pl(:,1),WD_pl(:,2),'k+');
    end
    if n_other~=0
        scatter(other_pole(:,1),other_pole(:,2),'k.');
    end
end

xlim([varargin{1}(1),varargin{1}(2)]);

set(gca,'XTick',0:0.1:varargin{1}(2));

xlabel('f/Hz');
ylabel('阶次');

basicFsize=10;  %基础字体大小

set(gca, 'FontSize', 2.5*basicFsize);
set(get(gca,'XLabel'),'Fontsize',3.0*basicFsize);
set(get(gca,'YLabel'),'Fontsize',3.0*basicFsize);

end
