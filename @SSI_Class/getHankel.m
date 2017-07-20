
%类方法名:getHankel
%类功能:计算Hankel矩阵
%传入参数:obj
%返回参数:obj

function obj=getHankel(obj)

imfh=obj.TData';
for i=0:2*obj.c-1                 %%%%%块行＝1:2i
    for j=1:obj.n-2*obj.c+1       %%%%%列＝1:n-2i+1
        for k=1:obj.l             %%%%%块行里的行＝测点数
            obj.hank(i*obj.l+k,j)=imfh(k,i+j)/((obj.n-2*obj.c+1)^0.5);
        end
    end
end

end
