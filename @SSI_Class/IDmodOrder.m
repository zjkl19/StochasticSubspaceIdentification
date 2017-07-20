

function IDmodOrder(obj,n,f)

M_f=f*ones(n,1);    %频率向量
delta=abs(M_f-obj.M_pl(1:n,n));

[~,I] = min(delta);
disp([num2str(f) '是' num2str(n) '阶系统中，第' num2str(I) '阶频率.']);

end
