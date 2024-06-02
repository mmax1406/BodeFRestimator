%% Create the signal 
clear all; close all; clc;

ff_max = 6;
Amp = 5;
dt = 1/4000;
uu = [];
ffVec = [];
for ff=1:2:ff_max
    T = 1/ff;
    tmp = Amp*sin(2*pi*ff*(0:dt:(5*T)));
    ffVec = [ffVec zeros(1,100) ff*ones(1,size(tmp,2))];  
    uu = [uu zeros(1,100) tmp];    
end
tt = dt * (0:size(uu,2)-1);

subplot(2,1,1);
plot(tt, ffVec)
subplot(2,1,2); 
plot(tt, uu)

%% Create the plant + simulate the response + Add some noise
s = tf('s');

yy = lsim(((100*2*pi)^2/(s^2+0.707*(100*2*pi)*s+(100*2*pi)^2)), uu, tt);
yy = awgn(yy,10,'measured'); % Add gaussian noise

% Filter using the frequency we know we recorded (Using filtfilt to not affect the phase)
wn = 1*2*pi;
BF = s*wn^2/(s+wn)^2;
BF_dig = c2d(BF, dt);
yy_filt = filtfilt(BF_dig.Numerator{:}, BF_dig.Denominator{:}, yy);

subplot(2,1,1);
plot(tt, yy);
subplot(2,1,2); 
plot(tt, yy_filt)