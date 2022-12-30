clc
clear all
tp=0.04;
%fs=400;%采样频率
N=2048;%设置采样点数
%tp=N/fs;%设置截取长度
fs=N/tp;%设置采样频率
n=1:1:N;
x=sin(100*pi*n/fs)+cos(200*pi*n/fs)+sin(50*pi*n/fs);%采样后的信号
%--------------------------------------------------------------------------
%加矩形窗函数进行采样
wn1=boxcar(N)';
x1=wn1.*x;%
figure('NumberTitle', 'off', 'name',strcat(num2str(N),'点DFT变换'));%给figure命名
subplot(2,2,1);
M=100;
stem(n(1,1:M),x1(1,1:M));
hold on;
plot(n(1,1:M),zeros(1,M),'k');
set(gca,'box','on');
xlabel('序列号');ylabel('序列值');
title('矩形窗采样后的序列x(n)');
subplot(2,2,2);
xk1=fft(x1)*2/N;
f=n*fs/N;
plot(f(1,1:150*tp),abs(xk1(1,1:150*tp)));
xlabel('频率f/Hz');ylabel('幅值');title('加矩形窗函数的DFT');
%---------------------------------------------------------------------------
%加hamming窗函数进行采样
wn2=hamming(N)';
x2=wn2.*x;%
subplot(2,2,3);
stem(n(1,1:M),x2(1,1:M));
hold on;
plot(n(1,1:M),zeros(1,M),'k');
set(gca,'box','on');
xlabel('序列号');ylabel('序列值');
title('hamming窗采样后的序列x(n)');
subplot(2,2,4);
xk2=fft(x2)*2/N;
f=n*fs/N;
plot(f(1,1:150*tp),abs(xk2(1,1:150*tp)));
xlabel('频率f/Hz');ylabel('幅值');title('加hamming窗函数的DFT');



