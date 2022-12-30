clear all
clc 
%读取音频文件
info =audioinfo('test.m4a')%获取音频文件的信息
[audio,Fs] = audioread('test.m4a');%读取音频文件
sound(audio,Fs);%播放音频文件
audiolength = length(audio);%获取音频文件的数据长度
t = 1:1:audiolength;
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
%添加多频噪声
f=3000;%设置噪声的频率
A=sqrt(1/audiolength*sum(audio.*audio))/5;%设置噪声幅
noise_1=A*(sin(2*pi*f/Fs*t)+sin(2*pi*50/Fs*t));%设置噪声序列
audio=audio + noise_1';%合成声音
pause(6);
clear sound ;
sound(audio,Fs);%播放音频文件
%绘制添加噪声后的频域与时域图像
subplot(2,2,3);
plot(t,audio(1:audiolength));
xlabel('Time');
ylabel('Audio Signal Amplitude');
title('加多频噪声后音频文件信号幅度图');
y =abs(fft(audio)*2/audiolength);
f=[0:(Fs/audiolength):Fs/2];     %转换横坐标以Hz为单位
y=y(1:length(f));
subplot(2,2,4);
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');