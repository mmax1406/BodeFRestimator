%% Create the signal 
clear all; close all; clc;

ff_max = 300;
Amp = 5;
dt = 1/4000;
uu = [];
freq = [];
for ff=1:2:ff_max
    T = 1/ff;
    tmp = Amp*sin(2*pi*ff*(0:dt:(5*T)));
    uu = [uu zeros(1,100) tmp];    
end

tt = dt * (0:size(uu,2)-1);

plot(tt, uu)

%% Create the plant + simulate the response + Add some noise
s = tf('s');

yy = lsim(tf((100*2*pi)^2/(s^2+0.707*(100*2*pi)*s+(100*2*pi)^2)), uu, tt);
plot(tt, awgn(yy,30,'measured'));
