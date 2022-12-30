clear all
clc 
close all
%--------------------------------------------------------------------------
%读取音频文件
info =audioinfo('test.m4a')%获取音频文件的信息
[audio,Fs] = audioread('test.m4a');%读取音频文件
sound(audio,Fs);%播放音频文件
audiolength = length(audio);%获取音频文件的数据长度
t = 1:1:audiolength;
%--------------------------------------------------------------------------
%绘制时域与频域图像
figure;
subplot(2,2,1);
plot(t,audio(1:audiolength));
xlabel('Time');
ylabel('Audio Signal Amplitude');
title('原始音频文件信号幅度图');
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
subplot(2,2,2);
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('原始音频文件信号频谱图');legend('Audio');
%--------------------------------------------------------------------------
%添加噪声
snr = 10; %设定信噪比，单位db
%输出参数data是带噪语音，noise为加在信号上的白噪声
[audio,noise] = Gnoisegen(audio,snr);%利用Gnoisegen函数添加白噪声
pause(6);
clear sound;
sound(audio,Fs)%添加噪声之后再次播放
%--------------------------------------------------------------------------
%绘制添加噪声后的频域与时域图像
subplot(2,2,3);
plot(t,audio(1:audiolength));
xlabel('Time');
ylabel('Audio Signal Amplitude');
title('加噪声后音频文件信号幅度图');
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
subplot(2,2,4);
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');
%--------------------------------------------------------------------------
%                          设计滤波器
Ap=2;As=25;%设置通带允许最大衰减设置为2dB，阻带应达到的最小衰减为25dB
F=4000;%通带截止频率
F_sh=15000;%阻带截止频率
%MATLAB工具函数常采用标准化频率，wp和ws的取值范围为0～1
wp=F*2/Fs; ws=F_sh*2/Fs;%所以通带截止频率为wp/pi ，阻带截止频率为ws/pi 
[N,wn]=cheb1ord(wp,ws,Ap,As);%计算切比雪夫Ⅰ型滤波器阶次和截止频率
[b,a]=cheby1(N,Ap,wn,'low');%频率变换法设计切比雪夫Ⅰ型低通滤波器
[db,mag,pha,grd,w]=freqz_m(b,a); 
%--------------------------------------------------------------------------
%                             绘图
figure;
subplot(2,2,2);
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');
subplot(2,2,3)
plot(w*Fs/(2*pi),db);%db为分贝，mag为增益
xlabel('f/Hz');%频率（HZ）
ylabel('幅度');
title([num2str(N),'阶数字低通切比雪夫Ⅰ型滤波器'])
grid on;
%--------------------------------------------------------------------------
%                       滤波
audio=filter(b,a,audio);%
subplot(2,2,4);
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('滤波后音频文件信号频谱图');legend('Audio');
pause(6);
clear sound ;
sound(audio,Fs);%播放音频文件
%添加噪声的函数Gnoisegen：
function [y,noise] = Gnoisegen(x,snr)
 
noise=randn(size(x));              % 用randn函数产生高斯白噪声
 
Nx=length(x);                      % 求出信号x长
 
signal_power = 1/Nx*sum(x.*x);     % 求出信号的平均能量
 
noise_power=1/Nx*sum(noise.*noise);% 求出噪声的能量
 
noise_variance = signal_power / ( 10^(snr/10) );    % 计算出噪声设定的方差值
 
noise=sqrt(noise_variance/noise_power)*noise;       % 按噪声的平均能量构成相应的白噪声
 
y=x+noise;                         % 合成带噪语音
end