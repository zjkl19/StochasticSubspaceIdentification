%控制台程序，MVC结构的一部分
classdef MainController < handle
    properties
        viewObj;    %controller对象必须拥有view对象的Handle
        modelObj;   %controller对象必须拥有model对象的Handle
    end
    methods
        
        function obj=MainController(viewObj,modelObj)   %controller类构造函数
            %初始化让控制器类对象拥有模型对象和视图对象的Handle
            obj.viewObj=viewObj;
            obj.modelObj=modelObj;
        end
        
        %MainView
        %计算
        callback_CalcButton(obj,src,event)
      
        %绘制稳定图
        callback_MakeStableButton(obj,src,event)
        
         %识别模态阶数
         callback_IDmodOrderButton(obj,src,event)
         
        %绘制振型图
        callback_PlotModeButton(obj,src,event)
        
        %重采样、滤波
        callback_ProcessButton(obj,src,event)
        
        %连接mod文件
        callback_ConnectButton(obj,src,event)
        
        %自定义功能
        callback_AdvanceButton(obj,src,event)
        
        %SSI聚类
        callback_SSIClusterButton(obj,src,event)
        
        %SSI图聚类
        callback_SSIMatSaveButton(obj,src,event)
        
        %"订制"功能
        callback_CustomButton(obj,src,event)
        
    end
end