%类方法名:obj=SSITable(obj,N)
        %类方法功能:计算最大至NN/2阶系统（NN/2个自由度)的各阶系统频率，阻尼比，振型，并将结果存入相应的矩阵
        %传入参数:obj   NN/2:最大计算系统阶数
        %返回参数:obj
        
        function obj=SSITable(obj,NN)
            %[A B]=sort(a); 返回a排序后的结果A。B为排序后数组A中各个元素在原矩阵中的位置
            %以下3个矩阵为别为储存结构各阶模态频率、阻尼比以及振型的矩阵
            %M_pl、M_znb矩阵行数从低到高表示阶数从低到高
            %NN=2*N;                        %投影矩阵阶数一致
            obj.M_pl=zeros(NN/2,NN/2);          %M_pl(i,j)按列向量储存各阶频率,即第j列表示第j阶模态的j个频率, M_pl(i,j)表示第j阶系统，第i个频率值
            obj.M_znb=zeros(NN/2,NN/2);         %M_znb(i,j)按列向量储存各阶模态,即第j列表示第j阶模态的j个阻尼比
            obj.M_zx=zeros(obj.l,NN/2,NN/2);    %M_zx(:,j,k) 振型为列向量，表示k阶系统，第j个模态振型
             
            
            %"完整版"
            obj.M_freq=zeros(NN,NN);
            obj.M_damp=zeros(NN,NN);
            obj.M_mshape=zeros(obj.l,NN,NN);
            obj.M_landa=zeros(NN,NN);    
            
            for n=2:2:NN                   %步长：2
                [w, z, cm, freq, damp, mshape, landa]=obj.CalcModal(n);      %计算求解出来的结果已经经过排序
                
                %SortedZnb=zeros(1,NN/2);
                %SortedModal=zeros(l,NN/2);
                
                if size(w,1)<NN/2
                    w=[w;zeros(NN/2-size(w,1),1)];        %列向量补0（方便数据处理，下同）
                    z=[z;zeros(NN/2-size(z,1),1)];
                    cm=[cm zeros(obj.l,NN/2-size(cm,2))];                    
                end
                
                obj.M_pl(:,n/2)=w;
                obj.M_znb(:,n/2)=z;
                obj.M_zx(:,:,n/2)=cm;
                
                if obj.considerEP==1
                    obj.M_eP=zeros(NN/2,NN/2);
                    if size(w,1)<NN/2
                        eP=[eP;zeros(NN/2-size(eP,1),1)];
                    end
                    obj.M_eP(:,n/2)=eP;
                end
               
                
                if size(freq,1)<NN
                    freq=[freq;zeros(NN-size(freq,1),1)];        %列向量补0（方便数据处理，下同）
                    damp=[damp;zeros(NN-size(damp,1),1)];
                    mshape=[mshape zeros(obj.l,NN-size(mshape,2))];
                    landa=[landa;zeros(NN-size(landa,1),1)];
                end
                
                obj.M_freq(:,n)=freq;
                obj.M_damp(:,n)=damp;
                obj.M_mshape(:,:,n)=mshape;
                obj.M_landa(:,n)=landa;
                
            end
            
            if obj.considerMSI==1
                obj.cmp_M_pl=zeros(NN/2,NN/2);
                obj.cmp_M_znb=zeros(NN/2,NN/2);
                obj.cmp_M_zx=zeros(obj.l,NN/2,NN/2);
                
                %"完整版"
                obj.cmp_M_freq=zeros(NN,NN);
                obj.cmp_M_damp=zeros(NN,NN);
                obj.cmp_M_mshape=zeros(obj.l,NN,NN);
                obj.cmp_M_landa=zeros(NN,NN);
                
                for n=2:2:NN                   %步长：2
                    [w, z, cm, freq, damp, mshape, landa]=obj.cmpCalcModal(n);      %计算求解出来的结果已经经过排序
                    
                    %SortedZnb=zeros(1,NN/2);
                    %SortedModal=zeros(l,NN/2);
                    
                    if size(w,1)<NN/2
                        w=[w;zeros(NN/2-size(w,1),1)];        %列向量补0（方便数据处理，下同）
                        z=[z;zeros(NN/2-size(z,1),1)];
                        cm=[cm zeros(obj.l,NN/2-size(cm,2))];
                    end
                    
                    obj.cmp_M_pl(:,n/2)=w;
                    obj.cmp_M_znb(:,n/2)=z;
                    obj.cmp_M_zx(:,:,n/2)=cm;
                    
                    if size(freq,1)<NN
                        freq=[freq;zeros(NN-size(freq,1),1)];        %列向量补0（方便数据处理，下同）
                        damp=[damp;zeros(NN-size(damp,1),1)];
                        mshape=[mshape zeros(obj.l,NN-size(mshape,2))];
                        landa=[landa;zeros(NN-size(landa,1),1)];
                    end
                    
                    obj.cmp_M_freq(:,n)=freq;
                    obj.cmp_M_damp(:,n)=damp;
                    obj.cmp_M_mshape(:,:,n)=mshape;
                    obj.cmp_M_landa(:,n)=landa;
                    
                end
            end
        end
        