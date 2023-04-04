%% 一階系統鑑別_Q1
clc;
clear;
close all;
%% 載入數據
load("Data1.mat")                                   
t = yout.time;
y = yout.signals(2).values(:,1);
% figure(1)
% plot(t,y,'LineWidth',2)

%% 參數設定
t_average= t';
y_average= y';
sim_ts=t_average(1,end)/length(t_average);      %求出取樣時間
sim_tend=t_average(1,end);                      %模擬終止時間
sigma = 1;                                      %步階響應震幅 
sim_t=0:sim_ts:sim_tend;                        %時間函數          
r=sigma*ones(1,length(sim_t));                  %輸入訊號
s=tf('s');                                      %定義拉氏轉換的變量s
y_steady_state_value = mean(y_average(1, find(t_average > 1,1):end));
%%  估測參數(時間常數方法)
tc_index = min(find(y_average > y_steady_state_value*0.63)); 
Tc = t_average(tc_index); 
a=Tc^-1;
Kn=(a* y_steady_state_value)/sigma; 
sys_id1 = tf(Kn/(s+a)) 
figure(2)
plot(t_average,y_average, t_average, ones(size(y_average))*y_steady_state_value , 'r');
xlabel('Time [s]'), ylabel('Velocity [V]')
%%  估測參數(上升時間方法)
tr90_index = min(find(y_average > y_steady_state_value*0.9));  %求出到達穩態90%時間的最小(第一個)陣列索引值

tr10_index = min(find(y_average > y_steady_state_value*0.1));  %求出到達穩態10%時間的最小(第一個)陣列索引值

Tr = t_average(tr90_index)-t_average(tr10_index);  %上升時間
a=2.2/Tr;
Kn=(a* y_steady_state_value)/sigma;
sys_id2 = tf(Kn/(s+a))
%%  估測參數(安定時間方法)
ts98_index = min(find(y_average > y_steady_state_value*0.98));  % 求出到達穩態98%時間的陣列索引值
Ts = t_average(ts98_index); % 安定時間
a = 4 / Ts;
Kn=(a* y_steady_state_value)/sigma;
sys_id3 = tf(Kn/(s+a))
%%  驗證
y_id1=lsim(sys_id1,r,sim_t); 
y_id2=lsim(sys_id2,r,sim_t); 
y_id3=lsim(sys_id3,r,sim_t); 

figure(3)
plot(t_average,y_average,sim_t,y_id1,sim_t,y_id2,sim_t,y_id3) 
legend('待鑑別波形','時間常數方法','上升時間方法','安定時間方法') 
xlabel('時間s'), ylabel('速度V') 