%AuxViewÍ¼ĞÎÖĞ
function Process(obj,ViewObj)
InputFile=ViewObj.APView.Input;
n=ViewObj.APView.Rate;       %Ñ¹ËõÂÊ
OutputFile=ViewObj.APView.Output;
ReSamFilter(InputFile,OutputFile,n);
end