%函数名称:getMAC
%函数功能:计算两个振型之间的MAC（Modal Assurance Criterion,模态保证准则）
%传入参数:M1,M2:一般情况下，M1和M2均为1维向量
%当M1和M2均为多维向量时，要求振型为列向量
%返回参数:
%当M1和M2均为1维向量时，返回单个mac
%当M1和M2均为2维及以上的向量时，返回多个mac
function MAC = getMAC( M1,M2 )

if ((size(M1,1)==1 || size(M1,2)==1) && (size(M2,1)==1 || size(M2,2)==1))  %均为1维的情况
    if size(M1,1)==1
        nN1=size(M1,2);
    else
        nN1=size(M1,1);
    end
    if size(M2,1)==1
        nN2=size(M2,2);
    else
        nN2=size(M2,1);
    end
    if nN1~=nN2
        error('nNs of M1 and nNs of M2 must be the same.');
    end
    
    if size(M1,2)~=1   %不是列向量
        M1=M1';
    end
    if size(M2,2)~=1   %不是列向量
        M2=M2';
    end         
    MAC=(M1'*M2)^2/((M1'*M1)*(M2'*M2));
else
    if size(M1)~=size(M2)   %多维传入参数必须进行认真检查
        error('Size of M1 & M2 must be the same.');
    end
    nModes=size(M1,2);
    MAC=zeros(1,nModes);  
    for i=1:nModes
        m1=M1(:,i);m2=M2(:,i);
        MAC(1,i)=(m1'*m2)^2/((m1'*m1)*(m2'*m2));
    end
end

end

