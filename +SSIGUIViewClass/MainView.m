%MVC结构的一部分，控制软件的视图
classdef MainView<handle
    properties
        viewSize;   %用于控制视图大小的数组
        
        hfig;   %视图类对象拥有figure的handle       
        TabFig; %Tab控件的handle
               
        MPView; %MainPanelView实例
        APView; %AuxPanleView实例
        EPView; %ExtraPanleView实例
        
        modelObj;   %视图类将拥有模型对象的handle
        controlObj; %视图类将拥有控制器对象的Handle
    end
    
    methods
        function obj=MainView(modelObj)     %View类的构造函数          
            obj.modelObj=modelObj;  %初始化View对象中模型的Handle
            
            %obj.modelObj.addlistener('balanceChanged',@obj.updateBalance);  %注册
            
            obj.buildUI();
            obj.controlObj=obj.makeMainController();    %view类负责产生controller
            obj.attachToController(obj.controlObj); %注册空间的回调函数
        end
                 
        %该函数负责从界面上得到用户的输入
           
        function buildUI(obj)   %构造界面并且展示给用户
            
            import SSIGUIViewClass.*;  
            %常量定义           
            scrsize=get(0,'ScreenSize');    %获取屏幕分辨率，输出：[left,bottom,width,height]
            MainWindowsSize=[320 360];      %主程序窗口宽度和高度（单位：像素）
            %figure的position中的[left bottom width height] 是指figure的可画图的部分的左下角的坐标以及宽度和高度
            %obj.viewSize=[程序左下角像素据显示器左下角宽度,程序左下角像素据显示器左下角高度,宽,高]
            obj.viewSize=[scrsize(3)/2-MainWindowsSize(1)/2,scrsize(4)/2-MainWindowsSize(2)/2,MainWindowsSize(1),MainWindowsSize(2)];
       
            obj.hfig=figure('pos',obj.viewSize,'NumberTitle','off','Menubar','none',...
                'Toolbar','none');
            obj.TabFig=uiextras.TabPanel('Parent',obj.hfig,'Padding',5);
            obj.MPView=MainPanelView(obj.TabFig);     
            obj.APView=AuxPanelView(obj.TabFig);
            obj.EPView=ExtraPanelView(obj.TabFig);
            
            obj.TabFig.TabNames={'主要功能','辅助功能','高级功能'};
            obj.TabFig.SelectedChild=1;
          
            %obj.updateBalance();
        end
        
        %更新程序界面上的数据时，用到的参考函数
        %function updateBalance(obj,scr,data)    
        %   set(obj.balanceBox,'string',num2str(obj.modelObj.balance));
        %end
        
        function MaincontrolObj=makeMainController(obj) %View负责产生自身的控制器
            MaincontrolObj=MainController(obj,obj.modelObj);
        end
               
        function attachToController(obj,controller)
            
            %MainPanelView
            funcH=@controller.callback_CalcButton;
            set(obj.MPView.CalcButton,'callback',funcH);
            
            funcH=@controller.callback_MakeStableButton;
            set(obj.MPView.MakeStableButton,'callback',funcH);
            
            funcH=@controller.callback_IDmodOrderButton;
            set(obj.MPView.IDmodOrderButton,'callback',funcH);
            
            funcH=@controller.callback_PlotModeButton;
            set(obj.MPView.PlotModeButton,'callback',funcH);
            
            funcH=@controller.callback_ProcessButton;
            set(obj.APView.ProcessButton,'callback',funcH);
            
            funcH=@controller.callback_ConnectButton;
            set(obj.APView.ConnectButton,'callback',funcH);
            
            funcH=@controller.callback_AdvanceButton;
            set(obj.EPView.AdvanceButton,'callback',funcH);
            
            funcH=@controller.callback_SSIClusterButton;
            set(obj.EPView.SSIClusterButton,'callback',funcH);
            
            funcH=@controller.callback_SSIMatSaveButton;
            set(obj.EPView.SSIMatSaveButton,'callback',funcH);
            
            funcH=@controller.callback_CustomButton;
            set(obj.EPView.CustomButton,'callback',funcH);
        end
    end
end









