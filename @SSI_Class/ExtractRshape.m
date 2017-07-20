 %类方法名称:ExtractRshape(obj)
        %类方法功能：由复模态提取实模态
        %传入参数：obj
        %返回参数:obj
        
        function obj=ExtractRshape(obj)
            %由复模态提取实模态
            %扩大模型法（Ibrahim法)
            %参考《模态分析理论与应用》 —— 傅志方 华宏星 P186
            %模态向量
            
            obj.M_Rshape=zeros(obj.l,obj.NN/2,obj.NN/2);
            
            %举例：
            %fai=[-2.6714 + 0.3163i  -2.6714 - 0.3163i 0.2536 - 0.1021i   0.2536 + 0.1021i;
            %    -4.3392 + 0.5137i  -4.3392 - 0.5137i -0.0881 + 0.0318i  -0.0881 - 0.0318i];
            
            %landa=[  0.9999 + 0.0124i 0.9999 - 0.0124i 0.9994 + 0.0398i 0.9994 - 0.0398i];
            
            %deltaT=obj.SF^-1;
            %deltaT=0.1;		%这个变量似乎和采样频率没有必然联系！
            deltaT=obj.SF^-1;
            
            for n=2:2:obj.NN            %按投影矩阵阶数遍历
                syms t;
                
                fai=obj.M_mshape(:,:,n);
                landa=obj.M_landa(:,n)';	%列转置为行，方便后面程序调用
                
                yt=0;
                Dyt=0;
                D2yt=0;
                
                
                for i=1:n   %此处n为Ibrahim算法中的2*m
                    yt=yt+fai(:,i)*exp(landa(i)*t);
                    Dyt=Dyt+fai(:,i)*landa(i)*exp(landa(i)*t);
                    D2yt=D2yt+fai(:,i)*landa(i)^2*exp(landa(i)*t);
                end
                
                %如果要求x的逆矩阵，n的值只能为obj.l
                t=0:deltaT:(2*obj.l-1)*deltaT;
                yt=subs(yt);Dyt=subs(Dyt);D2yt=subs(D2yt);
                
                X=[yt;Dyt]; DX=[Dyt;D2yt];
                
                A=DX*X^-1;
                
                RevM_K=-A(obj.l+1:end,1:obj.l);
                
                [psi,L] = eig(RevM_K);
                
                landa=diag(L);  %结果为列向量
                
                [~,I] = sort(abs(landa));
                
                psi=psi(:,I(1:end));
                
                
                
                %如果测点数比考虑的模态阶数多的话，会计算出比考虑阶数多的模态（但是在这个程序中会出错！健壮性的原因）
                if n<obj.NN
                    m_rshape=[psi zeros(obj.l,obj.NN/2-size(psi,2))];
                end
                
                obj.M_Rshape(:,:,n/2)=m_rshape;
            end
        end
        