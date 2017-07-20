function [WD,WD_DR,WD_Mode,WD_plzx,WD_plznb,WD_pl,other_pole ] = getStablePoles(obj)
%函数名称:getStablePoles
%函数功能:获取稳定点（含稳定点、频率振型、频率阻尼比、仅频率、其它点）
%传入参数：obj
%返回参数:稳定点、频率振型、频率阻尼比、仅频率、其它点

WD=[];WD_DR=[];WD_Mode=[];WD_plzx=[];WD_plznb=[];WD_pl=[];other_pole=[];

I=obj.II;

%绘制稳定图
nwd=0;          %稳定点个数初始化
nwd_plzx=0;     %频率和振型稳定
nwd_plznb=0;    %频率和阻尼比稳定
nwd_pl=0;       %只有频率稳定
n_other=0;   %除以上点之外的其他点

%实际上，XY最后的行数=0.5*(NN/2+1)*NN/2)，等差数列求和

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
            WD_DR(nwd)=obj.M_znb(j,i);             %Damp Ratio, 阻尼比
            WD_Mode(:,nwd)=real(obj.M_zx(:,j,i));           %Mode, 稳定点振型
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
        


end

