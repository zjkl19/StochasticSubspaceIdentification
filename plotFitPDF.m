%函数名称:plotFItPDF
%函数功能：绘制“距离”统计直方图，利用核函数拟合概率密度函数
%传入参数：distArray:必须为1维数组,按pdist函数格式生成的数组
%blks:分割的区间数
function plotFitPDF(distArray,blks)

    [rows,cols]=size(distArray);
    if (rows>1 && cols>1)
        error('At least one of the dimension of rows & columns has to be 1');
    end

    figure;
    [f_ecdf, xc] = ecdf(distArray);
    ecdfhist(f_ecdf, xc, blks);
    hold on;
    xlabel('x');  % 为X轴加标签
    ylabel('f(x)');  % 为Y轴加标签

    % 调用ksdensity函数进行核密度估计
    [f_ks1,xi1,~] = ksdensity(distArray,'support','positive');

    % 绘制核密度估计图，并设置线条为黑色实线，线宽为3
    plot(xi1,f_ks1,'r','linewidth',2)

    [maxPks,maxLocs]=findpeaks(f_ks1);     %查找极大值
    hold on
    plot(xi1(maxLocs),maxPks,'ro')
    [minPks,minLocs]=findpeaks(-f_ks1);    %查找极小值
    hold on
    plot(xi1(minLocs),-minPks,'ro');
end