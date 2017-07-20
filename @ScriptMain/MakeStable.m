%ªÊ÷∆Œ»∂®Õº
function MakeStable(obj,ViewObj)
figure(2);
%psize=size(ViewObj.MPView.PlotRange,2);
loc=find(ViewObj.MPView.PlotRange==':');
PR(1)=str2double(ViewObj.MPView.PlotRange(1:loc-1));
PR(2)=str2double(ViewObj.MPView.PlotRange(loc+1:end));
obj.SSIObj=obj.SSIObj.StablePlot(PR);
end