clear all
clc 
close all
% -------------------------------------------------------------------------
%                       读取音频文件设置参数
% -------------------------------------------------------------------------
info=audioinfo('test.m4a')%获取音频文件的信息
[audio,Fs] = audioread('test.m4a');%读取音频文件
sound(audio,Fs);%播放音频文件
[P,Q]=rat(20000/Fs);
audio=resample(audio,P,Q);%改变采样率
Fs=20000;%新的采样率
audiolength = length(audio);%获取音频文件的数据长度
t = 1:1:audiolength;
h=round(4000*audiolength/Fs);
%--------------------------------------------------------------------------
%                     绘制时域与频域图像
figure;
subplot(2,2,1);
plot(t,audio);
xlabel('Time');
ylabel('Audio Signal Amplitude');
title('原始音频文件信号幅度图');
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
subplot(2,2,2);
plot(f(1:h),y(1:h));
xlabel('频率(Hz)'); 
ylabel('幅度');
title('原始音频文件信号频谱图');legend('Audio');
% -------------------------------------------------------------------------
%                           添加噪声
% -------------------------------------------------------------------------
f=3000;%设置噪声的频率
A=sqrt(1/audiolength*sum(audio.*audio))/5;%设置噪声幅
noise_1=A*(sin(2*pi*f/Fs*t)+sin(2*pi*50/Fs*t));%设置噪声序列
audio=audio + noise_1';%合成声音
pause(6);
clear sound ;
sound(audio,Fs);%播放音频文件
%--------------------------------------------------------------------------
%                     绘制添加噪声后的频域与时域图像
% -------------------------------------------------------------------------
subplot(2,2,3);
plot(t,audio);
xlabel('Time');
ylabel('Audio Signal Amplitude');
title('加噪声后音频文件信号幅度图');
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
subplot(2,2,4);
plot(f(1:h),y(1:h));
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');
%--------------------------------------------------------------------------
%                              滤波器设计
%--------------------------------------------------------------------------
fp=200;fsl=2700;fsu=3300;%设置截止频率
N=ceil(6.6*pi/(1000)*Fs);% 根据过渡带宽度求滤波器阶数
wc=[fp,fsl,fsu]./(Fs/2);%对pi进行数字频率归一化
b = fir1(100, wc(1), 'high');   %100阶FIR高通滤波器
b1=fir1(N+1, wc(2:3), 'stop');    %100阶FIR带阻滤波器
[db,mag,pha,grd,w]=freqz_m(b,1); 
[db1,mag1,pha1,grd1,w1]=freqz_m(b1,1); 
figure;
subplot(2,2,2);
plot(f(1:h),y(1:h));
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');
subplot(2,2,1)
plot(w1*Fs/(2*pi),db1);%db为分贝，mag为增益
xlabel('f/Hz');%频率（HZ）
ylabel('幅度/dB');
title( [num2str(N+1),'阶FIR带阻滤波器']);
grid on;
subplot(2,2,3)
plot(w*Fs/(2*pi),db);%db为分贝，mag为增益
xlabel('f/Hz');%频率（HZ）
ylabel('幅度/dB');
title( 'FIR高通滤波器')
grid on;
%--------------------------------------------------------------------------
%                     进行滤波
audio=filtfilt(b,1,audio);           %经过FIR滤波器后得到的信号
audio=filtfilt(b1,1,audio);
subplot(2,2,4);
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
plot(f(1:h),y(1:h));
xlabel('频率(Hz)'); 
ylabel('幅度');
ylim([0,0.1]);%对Y轴设定显示范围
title('滤波后音频文件信号频谱图');legend('Audio');
pause(6);
clear sound ;
sound(audio,Fs);%播放音频文件