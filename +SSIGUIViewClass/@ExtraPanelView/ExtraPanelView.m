classdef ExtraPanelView<handle
   properties(Access=public)
       a    
       %按钮
        AdvanceButton
        SSIClusterButton
        SSIMatSaveButton
        CustomButton
   end
   
   methods
       function obj=ExtraPanelView(hfig)     %构造函数
         
            mainLayout=uiextras.VBox('Parent',hfig,'Padding',5,'Spacing',10);   %界面主框架
            
            LayoutSpacing=5;                                        %对象与对象之间的间隔，单位：像素
            MyFontSize=10;                                          %字体的大小
  
            %Padding制定figure到VBox的边缘是5像素
            %进行整体布局
            Layout{1}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);               %第1层
            Layout{2}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);
             Layout{3}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);
             Layout{4}=uiextras.HBox('Parent',mainLayout,'Spacing',LayoutSpacing);

            %第1层控制细节
            obj.AdvanceButton=uicontrol('style','pushbutton','string','运行高级功能','Parent',Layout{1},'FontSize',MyFontSize);
            
            %SSI聚类
            obj.SSIClusterButton=uicontrol('style','pushbutton','string','SSI聚类','Parent',Layout{2},'FontSize',MyFontSize);
            
            %SSI图聚类
            obj.SSIMatSaveButton=uicontrol('style','pushbutton','string','保存SSI Mat文件','Parent',Layout{3},'FontSize',MyFontSize);
            
            %订制功能按钮  一般为作者使用
            obj.CustomButton=uicontrol('style','pushbutton','string','订制功能','Parent',Layout{4},'FontSize',MyFontSize);

       end
   end
end