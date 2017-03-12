clear all; clc;
%% erwthma 4.2

%% 1
load('speech_signal-1.mat');
x = s5;
nstart = 17200;
ninc = 200;
nwin = 401;
nfft = 512;
nsect = 10;
pltinc = 50;

figure(1);
stspect(x, nstart, ninc, nwin, nfft, nsect, pltinc);

%% 2
B = [1 -0.98]; A = 1;
y1 = filter(B,A,x);

figure(2);
stspect(y1, nstart, ninc, nwin, nfft, nsect, pltinc);
