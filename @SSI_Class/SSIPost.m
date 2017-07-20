%类方法名:SSIPost(obj)
%类方法功能:根据计算出来的稳定图，绘制模态振型图
%绘制第k阶系统的第j阶模态振型
%传入参数:只解释varargin参数
%varargin为2个：
%j=varargin{1}：模态阶数
%k=varargin{2}:系统阶数
%varargin为3个：
%shape=varargin{1};振型矩阵
%j=varargin{2};模态阶数
%k=varargin{3};系统阶数

%返回参数:obj

%function obj=SSIPost(obj, shape,j,k)
function obj=SSIPost(obj,varargin)

    if nargin==3
        j=varargin{1};k=varargin{2};
        plot( real(obj.M_zx(:,j,k)));
    elseif nargin==4
        shape=varargin{1};j=varargin{2};k=varargin{3};
        plot(real(shape(:,j,k)));
    else
        error('Wrong input arguments.');
    end
end