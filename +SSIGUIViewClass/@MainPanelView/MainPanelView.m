classdef MainPanelView<handle
    properties
        PathInfoBox
        
        CalcButton
        
        PlotRangeBox
        
        MakeStableButton
        
        OrderFreqBox
        
        IDmodOrderButton
        
        SystemOrderBox
        
        ModalOrderBox
        
        PlotModeButton
    end
    properties(Dependent)
        PathInfo;     %原始数据路径
        OrderFreq;
        SystemOrder;     %
        ModalOrder;     %
        PlotRange;
    end
    methods
         %该函数负责从界面上得到用户的输入
        function pValue = get.PathInfo(obj)   
            pValue=get(obj.PathInfoBox,'string');    %原始数据文件路径
        end
        
        function v = get.OrderFreq(obj)   
            v =get(obj.OrderFreqBox,'string');        
        end
        
        function v = get.SystemOrder(obj)   
            v =get(obj.SystemOrderBox,'string');        %系统阶数
            v=str2double(v);
        end
        
       function v = get.ModalOrder(obj)   
            v =get(obj.ModalOrderBox,'string');        %模态阶数
             v=str2double(v);
       end
        
      function v = get.PlotRange(obj)   
            v =get(obj.PlotRangeBox,'string');        
  
        end
         
        %h:图形句柄
        %mainLayout:
         function obj=MainPanelView(hfig)     %构造函数
                      
            PromptString{1}='数据文件路径：';                            %提示字符串
            PromptString{2}='系统阶数：';        
            PromptString{3}='模态阶数：'; 
            TextBoxString{1}='Y.txt';      %文本框默认文字
            PushButtonString{1}={'计算'};
            PushButtonString{2}={'作稳定图'};
            PushButtonString{3}={'绘制振型图'};
            CopyrightInfo='软件版本1.2 beta Copyright 2015 林迪南';  %版本，版权信息文字

            mainLayout=uiextras.VBox('Parent',hfig,'Padding',5,'Spacing',10);   %界面主框架
            
            LayoutSpacing=5;                                        %对象与对象之间的间隔，单位：像素
            MyFontSize=10;                                          %字体的大小
  
            %Padding制定figure到VBox的边缘是5像素
            %进行整体布局
            Layout{1}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第一层
            Layout{2}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第二层
            Layout{3}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第三层
            Layout{4}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第四层
            Layout{5}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第五层
            Layout{6}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第五层
            LayoutBottom=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);            %底层，布置版本，版权等信息
            
            nL=size(Layout,2)+1;
            nLMatrix=-ones(1,nL);
            set(mainLayout,'Sizes',nLMatrix,'Spacing',10);      
            
            %set(mainLayout,'Sizes',[-1 -1 -1 -1 -1 -1],'Spacing',10);       %设置各个控件大小的比例为：1:1:1:1:1:1
        
            %第一层控制细节
            w11=uiextras.VBox('Parent',Layout{1},'Spacing',5);   %第1层第1个竖向窗口
            uicontrol('style','text','string',PromptString{1},'Parent',w11,'FontSize',MyFontSize);
   
            w12=uiextras.VBox('Parent',Layout{1},'Spacing',5);    %第1层第2个竖向窗口
            obj.PathInfoBox=uicontrol('style','edit','string',TextBoxString{1},'Parent',w12,'FontSize',MyFontSize);
            
            w13=uiextras.VBox('Parent',Layout{1},'Spacing',5);    %第1层第2个竖向窗口
            obj.CalcButton=uicontrol('style','pushbutton','string',PushButtonString{1},'Parent',w13,'FontSize',MyFontSize);
            %set(Layout{1},'Sizes',[-1 -1],'Spacing',10);
                   
            %第二层控制细节
            w21=uiextras.VBox('Parent',Layout{2},'Spacing',5);   %第3层第1个竖向窗口
            uicontrol('style','text','string','关注频率范围：','Parent',w21,'FontSize',MyFontSize-1);
      
            w22=uiextras.VBox('Parent',Layout{2},'Spacing',5);    %第3层第2个竖向窗口
            obj.PlotRangeBox=uicontrol('style','edit','string','0:3','Parent',w22,'FontSize',MyFontSize);
  
            w23=uiextras.VBox('Parent',Layout{2},'Spacing',5);   
            obj.MakeStableButton=uicontrol('style','pushbutton','string',PushButtonString{2},'Parent',w23,'FontSize',MyFontSize);
            set(Layout{2},'Sizes',[-1 -1 -1],'Spacing',10);
            %uicontrol('style','text','string','请选择计算内容：','Parent',Layout2nd,'FontSize',MyFontSize);       
            
            %第三层控制细节
            w31=uiextras.VBox('Parent',Layout{3},'Spacing',5);   %第3层第1个竖向窗口
            uicontrol('style','text','string','系统阶数，频率：','Parent',w31,'FontSize',MyFontSize-1);
      
            w32=uiextras.VBox('Parent',Layout{3},'Spacing',5);    %第3层第2个竖向窗口
            obj.OrderFreqBox=uicontrol('style','edit','string','5,0.51','Parent',w32,'FontSize',MyFontSize);
  
            w33=uiextras.VBox('Parent',Layout{3},'Spacing',5);   
            obj.IDmodOrderButton=uicontrol('style','pushbutton','string','识别模态阶数','Parent',w33,'FontSize',MyFontSize);
            %set(Layout{3},'Sizes',[-1 -1 -1],'Spacing',10);
            
            %第四层控制细节          
            w41=uiextras.VBox('Parent',Layout{4},'Spacing',5);   %第4层第1个竖向窗口
            uicontrol('style','text','string',PromptString{2},'Parent',w41,'FontSize',MyFontSize);
                                    

            w42=uiextras.VBox('Parent',Layout{4},'Spacing',5);  %第4层第2个竖向窗口
            obj.SystemOrderBox=uicontrol('style','edit','string','','Parent',w42,'FontSize',MyFontSize);
            
            w43=uiextras.VBox('Parent',Layout{4},'Spacing',5);   %第4层第3个竖向窗口
            uicontrol('style','text','string',PromptString{3},'Parent',w43,'FontSize',MyFontSize);
            
            w44=uiextras.VBox('Parent',Layout{4},'Spacing',5);    %第4层第4个竖向窗口
            obj.ModalOrderBox=uicontrol('style','edit','string','','Parent',w44,'FontSize',MyFontSize);
            
            set(Layout{4},'Sizes',[-1 -1 -1 -1],'Spacing',MyFontSize-1);
           
            %第5层控制细节           
            obj.PlotModeButton=uicontrol('style','pushbutton','string',PushButtonString{3},'Parent',Layout{5},'FontSize',MyFontSize);
            
            %第6层控制细节          
            w61=uiextras.VBox('Parent',Layout{6},'Spacing',5);   %第6层第1个竖向窗口
            uicontrol('style','text','string','配置文件:','Parent',w61,'FontSize',MyFontSize);
            
            w62=uiextras.VBox('Parent',Layout{6},'Spacing',5);   
            uicontrol('style','edit','string','cf.txt','Parent',w62,'FontSize',MyFontSize);
                                    

            w63=uiextras.VBox('Parent',Layout{6},'Spacing',5); 
            uicontrol('style','pushbutton','string','写入','Parent',w63,'FontSize',MyFontSize);
            
            %底层控制细节
            uicontrol('style','text','string',CopyrightInfo,'Parent',LayoutBottom,'FontSize',MyFontSize);
            
        end
        
    end
end