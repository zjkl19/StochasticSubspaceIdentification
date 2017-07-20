       %识别模态阶数
        function IDmodOrder(obj,ViewObj)

            loc=find(ViewObj.MPView.OrderFreq==',');
            n=str2double(ViewObj.MPView.OrderFreq(1:loc-1));
            f=str2double(ViewObj.MPView.OrderFreq(loc+1:end));
            obj.SSIObj.IDmodOrder(n,f);
        end