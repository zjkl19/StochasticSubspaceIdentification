%客户端程序
classdef ScriptMain<handle
    properties(Access=public)
        %--------程序规模变大以后，需要使用以下两个变量-----------------
        BridgeObj
        FactoryObj
        %---------------------------------------------------------------
        
        SSIObj
        
    end
    events
        ButtonClick    %按下计算按钮
    end
    methods(Access=public)
 
        %进行奇异值分解，计算投影矩阵，计算各阶系统情况下，结构的模态参数
        StartCalculation(obj,ViewObj)
 
        %绘制稳定图
        MakeStable(obj,ViewObj)
                    
        %识别模态阶数
        IDmodOrder(obj,ViewObj)
        
        %绘制模态振型图
        PlotMode(obj,ViewObj)
            
        %AuxView图形中
        Process(obj,ViewObj)           
        
        StartAdvance(obj,ViewObj)
        
        SSIGraphCluster(obj,ViewObj)
        
        Custom(obj,ViewObj)
          
    end
    
    
end
