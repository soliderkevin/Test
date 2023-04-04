%% 二階系統鑑別_Q2
clc; 
clear;
clf;
%% 載入波型
load('data2.mat') 
% c = tf(num,den); %c為轉移函數
% [y,x]=step(c,t); %x為時間;y為響應
y_average= y';
sim_ts=t(1,end)/length(t);      %求出取樣時間
sim_tend=t(1,end);                      %模擬終止時間
sigma = 1;                                      %步階響應震幅 
sim_t=0:sim_ts:sim_tend;                        %時間函數
r=sigma*ones(1,length(sim_t));                  %輸入訊號
s=tf('s');                                      %定義拉氏轉換的變量s
y_steady_state_value = mean(y_average(1, find(t > 1,1):end));  % steady_state_value
%% 求出Ts、Tp
ts98_index = find(y_average > y_steady_state_value*0.98 & y_average < y_steady_state_value*1.02);
T_settle = t(ts98_index);
Ts_accord = flip(T_settle,2); 
for i = 1 : length(Ts_accord)-1
    if Ts_accord(i) - Ts_accord(i+1) > 0.0101 
       Ts = Ts_accord(i);
       break

    else  
        continue
    end
end
Tp_value = max(y_average); 
Tp = t(find(y_average == Tp_value)); 
%% 用Ts、Tp推出omga、zeta*omga
Re = 4 / Ts;
Im = pi / Tp;
b = Tp * Re / pi;
a = b^2;
zeta = sqrt((a)/(1 + a));
Wn = Re / zeta;

den2 = [1 2*zeta*Wn Wn^2];
num2 = Wn^2;
c2 = tf(num2,den2) 

%% 驗證
y_id2 = lsim(c2,r,sim_t); 

figure(1)
plot(t,y_average,sim_t,y_id2)
legend('待鑑別波型','二階系統鑑別') 