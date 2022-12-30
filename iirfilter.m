clear all
clc 
%--------------------------------------------------------------------------
%读取音频文件
info =audioinfo('test.m4a')%获取音频文件的信息
[audio,Fs] = audioread('test.m4a');%读取音频文件
sound(audio,Fs);%播放音频文件
audiolength = length(audio);%获取音频文件的数据长度
t = 1:1:audiolength;
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
%                    添加单频噪声
f=5000;%设置噪声的频率
A=sqrt(1/audiolength*sum(audio.*audio))/10;%设置噪声幅
noise_1=A*sin(2*pi*f/Fs*t);%设置噪声序列
audio=audio + noise_1';%合成声音
pause(6);
clear sound ;
sound(audio,Fs);%播放音频文件
%--------------------------------------------------------------------------
%           绘制添加噪声后的频域与时域图像
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
%                       设计滤波器
Fs=44100;%给定抽样频率
wp_d=4900;%阻带下限截止频率
wp_s=5100;%阻带上限截止频率
ws_d=4700;%通带下限截止频率
ws_s=5300;%通带上限截止频率
wp=[wp_d wp_s]*2/Fs; ws=[ws_d ws_s]*2/Fs;%计算阻带截止频率wp，通带频率ws
Ap=1;As=5;%设置通带允许最大衰减设置为3dB，阻带应达到的最小衰减为18dB
[N,wn]=buttord(wp,ws,Ap,As);%计算巴特沃斯滤波器阶次和截止频率
%N为滤波器阶数 wn为滤波器截止频率 数字滤波器
[b,a]=butter(N,wn,'stop');%频率变换法设计巴特沃斯带阻滤波器
[db,mag,pha,grd,w]=freqz_m(b,a); %求出巴特沃斯带阻滤波器幅频、幅度、相位等
%--------------------------------------------------------------------------
%                     绘制滤波器频响曲线
figure;
subplot(2,2,3);
plot(w*Fs/(2*pi),db);%db为分贝，mag为增益
xlabel('f/Hz');%频率（HZ）
ylabel('幅度');
title([num2str(N),'阶数字带阻巴特沃斯滤波器'])
grid on;
subplot(2,2,2);
plot(f,y);
xlabel('频率(Hz)'); 
ylabel('幅度');
title('加噪声后音频文件信号频谱图');legend('Audio');
%--------------------------------------------------------------------------
%                            进行滤波
audio=filter(b,a,audio);
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