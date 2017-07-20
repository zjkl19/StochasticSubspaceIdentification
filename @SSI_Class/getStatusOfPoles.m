function obj = getStatusOfPoles(obj)
%函数名称:getStatusOfPoles
%函数功能:获取各阶“模型”各极点的状态
%传入参数：obj
%返回参数：obj

BigNum=1000;    %BigNum简单地讲就是为了数据处理的方便
%后面有个阈值识别矩阵，后面稳定点识别的阈值都很小
%如果预定义一个大值，就是默认该点不是稳定点
obj.Indicator=ones(obj.NN/2,3,obj.NN/2);   %obj.Indicator(i,j,k)指标矩阵，表示第k阶系统，第i阶模态的3个指标（特征频率，阻尼比，模态振型）
obj.Indicator=BigNum*obj.Indicator;       %乘1个大数

for i=2:obj.NN/2        %遍历各阶系统
    for j=1:(i-1)       %遍历系统中各阶模态
        obj.Indicator(j,1,i)=(obj.M_pl(j,i)-obj.M_pl(j,i-1))/obj.M_pl(j,i-1);
        obj.Indicator(j,1,i)=abs(obj.Indicator(j,1,i));
        
        obj.Indicator(j,2,i)=(obj.M_znb(j,i)-obj.M_znb(j,i-1))/obj.M_znb(j,i-1);
        obj.Indicator(j,2,i)=abs(obj.Indicator(j,2,i));
        
        obj.Indicator(j,3,i)=(obj.M_zx(:,j,i)'*obj.M_zx(:,j,i-1))^2/ (obj.M_zx(:,j,i)'*obj.M_zx(:,j,i) * obj.M_zx(:,j,i-1)'*obj.M_zx(:,j,i-1)) ;
        obj.Indicator(j,3,i)=abs(obj.Indicator(j,3,i));
        obj.Indicator(j,3,i)=abs(1-obj.Indicator(j,3,i));
        
    end
end

if obj.considerMSI==1
    
    Wf=0.5; Wkesi=0.2; WMAC=0.3;
    df=0.15;dkesi=0.30;dMAC=0.20;
    %MSItor=1; %模态相似指数容差
    obj.MSI=zeros(obj.NN/2,obj.NN/2);           %模态相似指数
    
    for i=2:obj.NN/2        %遍历各阶系统
        for j=1:(i-1)       %遍历系统中各阶模态
            obj.MSI(i,j)=(Wf/df)*abs(obj.M_pl(j,i)-obj.cmp_M_pl(j,i))/max(obj.M_pl(j,i),obj.cmp_M_pl(j,i)) ...,
                +(Wkesi/dkesi)*abs(obj.M_znb(j,i)-obj.cmp_M_znb(j,i))/max(obj.M_znb(j,i),obj.cmp_M_znb(j,i))  ...,
                +(WMAC/dMAC)*(1-getMAC(obj.M_zx(:,j,i),obj.cmp_M_zx(:,j,i)));
        end
    end
end

end

