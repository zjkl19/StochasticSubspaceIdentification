        %绘制模态振型图
        function PlotMode(obj,ViewObj)
            %PostProcessing
            %后处理
            figure(3);
            j=ViewObj.MPView.ModalOrder;
            k=ViewObj.MPView.SystemOrder;
            obj.SSIObj.SSIRegM(obj.SSIObj.M_zx);      %将稳定图中的所有振型标准化（第1个测点归一化）
            obj.SSIObj.SSIPost(obj.SSIObj.RegShape,j,k);%绘制第k阶系统，j阶模态
        end