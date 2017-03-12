clear all; clc;
%% erwthma 4.1

%% 4.1.2
load('speech_signal-1.mat');
x = s5;

% Sample number that windows are centered on
ncenter = [3750, 16100, 17200]; 
win = [401, 201, 101, 51]; % Vector of windows to use
nfft = 512; % FFT size
pltinc = 20; % Offset of plots (in dB)

sz = size(ncenter);
% For each center
for i = 1:sz(1, 2);
    figure(i);
    speccomp(x, ncenter(i), win, nfft, pltinc);    
end

%% 4.1.5
B = [1 -0.98]; A = 1;

y1 = filter(B,A,x);

for i = 1:sz(1, 2);
    figure(i+3);
    speccomp(y1, ncenter(i), win, nfft, pltinc);    
end