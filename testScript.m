
%nn=50;

%for loopi=1:nn
%    figure(5);
%    stem(modelObj.SSIObj.M_pl(1:loopi,loopi),modelObj.SSIObj.M_eP(1:loopi,loopi));
%end

clear;clc;

load('G:\科研、横向、程序、教程（最重要的1个文件夹）\同学、教研室同门\郑沛娟\ldnSSI\SSI_class\20y\20140327\SSI2014-03-27 10-46-26.mat');
[WD,WD_DR,WD_Mode]=rmAbnormWD(WD,WD_DR,WD_Mode);
nwd=size(WD,1);

kwd=0;
k=1;

for i=1:nwd
    if WD(i,1)<1.2
        wd(k,:)=WD(i,:);
        k=k+1;
        kwd=kwd+1;
    end
end
WD=wd;
nwd=kwd;

WD_dist=pdist(WD(:,1));


LinkWD =linkage(WD(:,1));


s=[];t=[];
%s=zeros(1,0.5*(nwd^2-nwd));
%t=zeros(1,0.5*(nwd^2-nwd));
for i=1:nwd-1
    s=[s i*ones(1,nwd-i)];
    t=[t (i+1):nwd];
end
weights=pdist(WD(:,1));
G = graph(s,t,weights);
figure;

[T,pred] = minspantree(G);

x=WD(:,1)';
y=WD(:,2)';

plot(T,'XData',x,'YData',y,'Marker','o','MarkerSize',3, ... 
    'NodeColor','black','EdgeColor','black','LineStyle','--','LineWidth',0.75)
%Marker:结点样式
%MarkerSize:点大小

xlim([0 1.2]);

set(gca,'XTick',0:0.1:1.2);
ylim([0 55]);
set(gca,'YTick',0:5:55);

xlabel('f/Hz');
ylabel('阶次');

basicFsize=10;  %基础字体大小

set(gca, 'FontSize', 2.5*basicFsize);
set(get(gca,'XLabel'),'Fontsize',3.0*basicFsize);
set(get(gca,'YLabel'),'Fontsize',3.0*basicFsize);




