%% 二階系統鑑別_Q3
clc ;
clear;
close all;
%% 載入波形
load("B_noise_speed_data1.mat")
t = B_noise_speed_data1(1,:);
y = B_noise_speed_data1(2,:);
figure(1) 
plot(t,y,'LineWidth',1.5)

%% 初始設定
sim_ts=t(1,end)/length(t);      %取樣時間
sim_tend=t(1,end);              %模擬終止時間
sigma = 12;                     %步階響應震幅
sim_t=0:sim_ts:sim_tend;        %時間函數          
r=sigma*ones(1,length(sim_t));  %輸入訊號
y_n=lowpass(y,50,1/sim_ts);    %低通濾波

%%  compute Kp<=>y0(inf)
y0_steady_state_value = mean( y_n(1, find(t > 0.5,1):end) );
Kp = y0_steady_state_value;
%%  compute K1<=>y1(inf)
y1_t = Kp * ones(1,length(y_n)) - y_n;
y1 = cumtrapz(t,y1_t);
y1_steady_state_value = mean( y1(1, find(t > 1,1):end) ); 
K1 = y1_steady_state_value; 

%%  compute K2 <=> y2(inf)
y2_t = K1 * ones(1,length(y1)) - y1; 
y2 = cumtrapz(t,y2_t);
y2_steady_state_value = mean( y2(1, find(t > 1,1):end) );
K2 = y2_steady_state_value;

%% compute K0,a1,a2
K0 = Kp / sigma; 
a1 = K1 / Kp; 
a2 = (a1 * K1 - K2) / Kp;
s=tf('s');
sys_id = tf(K0 / (a2 * s^2 + a1 * s + 1))

%%  驗證
y_id = lsim(sys_id,r,sim_t); 

figure(1)
plot(t,y_n,sim_t,y_id) 
legend('待鑑別波型','二階系統鑑別') 
xlabel('時間s'), ylabel('速度V') 