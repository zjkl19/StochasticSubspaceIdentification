classdef AuxPanelView<handle
   properties(Access=public)
       a
       
       %各文本框
       InputBox
       RateBox
       OutputBox
       
       %各个按钮
       ProcessButton
       ConnectButton
   end
   properties(Dependent)
        Input;     %输入文件路径
        Rate;       %压缩率
        Output;    %输出文件路径
        
    end
   methods

        function v = get.Input(obj)   
            v=get(obj.InputBox,'string');    %原始数据文件路径
        end
        
       function v = get.Rate(obj)   
            v=get(obj.RateBox,'string');    %原始数据文件路径
            v=str2double(v);
        end
        
        function v = get.Output(obj)   
            v=get(obj.OutputBox,'string');    %原始数据文件路径
        end
       
       function obj=AuxPanelView(hfig)     %构造函数
      
            
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
            Layout{7}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第五层
            %第1层控制细节
            
            uicontrol('style','text','string','滤波和重采样：','Parent',Layout{1},'FontSize',MyFontSize);
            
            %第2层控制细节
            w21=uiextras.VBox('Parent',Layout{2},'Spacing',5);  
            uicontrol('style','text','string','输入文件路径：','Parent',w21,'FontSize',MyFontSize-1);
            w22=uiextras.VBox('Parent',Layout{2},'Spacing',5);    
            obj.InputBox=uicontrol('style','edit','string','in.txt','Parent',w22,'FontSize',MyFontSize);
            w23=uiextras.VBox('Parent',Layout{2},'Spacing',5);    
            uicontrol('style','text','string','压缩率：','Parent',w23,'FontSize',MyFontSize-1);
            w24=uiextras.VBox('Parent',Layout{2},'Spacing',5);    
            obj.RateBox=uicontrol('style','edit','string','10','Parent',w24,'FontSize',MyFontSize);
            
            %第3层控制细节
            w31=uiextras.VBox('Parent',Layout{3},'Spacing',5);  
            uicontrol('style','text','string','输出文件路径：','Parent',w31,'FontSize',MyFontSize-1);
            w32=uiextras.VBox('Parent',Layout{3},'Spacing',5);    
            obj.OutputBox=uicontrol('style','edit','string','out.txt','Parent',w32,'FontSize',MyFontSize);
            w33=uiextras.VBox('Parent',Layout{3},'Spacing',5); 
            obj.ProcessButton=uicontrol('style','pushbutton','string','处理!','Parent',w33,'FontSize',MyFontSize);
            
           %第4层控制细节
            w41=uiextras.VBox('Parent',Layout{4},'Spacing',5);  
            uicontrol('style','text','string','连接mod文件：','Parent',w41,'FontSize',MyFontSize-1);
            
            %第5层控制细节
            w51=uiextras.VBox('Parent',Layout{5},'Spacing',5);  
            uicontrol('style','text','string','mod文件夹路径：','Parent',w51,'FontSize',MyFontSize-1);
            w51=uiextras.VBox('Parent',Layout{5},'Spacing',5);  
            uicontrol('style','edit','string','ModFolder','Parent',w51,'FontSize',MyFontSize-1);
            
            %第6层控制细节
            w61=uiextras.VBox('Parent',Layout{6},'Spacing',5);  
            uicontrol('style','text','string','输出文件名：','Parent',w61,'FontSize',MyFontSize-1);
            w62=uiextras.VBox('Parent',Layout{6},'Spacing',5);  
            uicontrol('style','edit','string','OutFile.txt','Parent',w62,'FontSize',MyFontSize-1);
            w63=uiextras.VBox('Parent',Layout{6},'Spacing',5); 
            obj.ConnectButton=uicontrol('style','pushbutton','string','连接','Parent',w63,'FontSize',MyFontSize);

            
            obj.a=1;
       end
   end
end