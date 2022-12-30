%近似绘制时域图像
subplot(2,1,1);
t=1:1:1000;
fs1=4000;
xt=sin(100*pi*t/fs1)+cos(200*pi*t/fs1)+sin(50*pi*t/fs1);
plot(t/fs1,xt);
hold on 
plot(t/fs1,zeros(1,length(t)),'k');
xlabel('时间/s');ylabel('x(t)值');
title('时域连续时间信号');
%进行采样
n=1:1:100;
fs=400;%设置采样频率
x=sin(100*pi*n/fs)+cos(200*pi*n/fs)+sin(50*pi*n/fs);%采样后的信号
subplot(2,1,2);
stem(n,x);
hold on;
plot(n,zeros(1,length(n)),'k');
set(gca,'box','on');
xlabel('序列号');ylabel('序列值');
title('采样后的序列x(n)');