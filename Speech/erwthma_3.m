clear all; clc;
%% Erwthma 3.1

load('speech_signal-1.mat');
x = s5;
sz = size(x);

a = [0.5, 0.8, 0.98];
fs = 8000; % Sampling frequency
H = zeros(fs, 3); 
h = zeros(fs, 3);

% H(z) = 1 - a*z^(-1)  Transfer function
% Z transform of: y[n] = x[n] - a*x[n-1]

for i = 1:3
    B = [1 -a(i)]; A = 1;
    
    w = 0:pi/fs:pi;
    w = w(1, 1:fs);

    H(:, i) = freqz(B, A, fs); % Frequency Response
    h(:, i) = ifft(H(:, i)); % Impulse Response
    
end

figure(1)
plot(w./pi, H(:, 1),w./pi, H(:, 2),w./pi, H(:, 3));
legend('a = 0.5', 'a = 0.8', 'a = 0.98');
title('Pre-emphasis filter');
xlabel('Normalized Frequencies');
ylabel('Magnitude');

%% Erwthma 3.2

B = [1 -0.98]; A = 1;

y1 = filter(B, A, x);

y2 = real(conv(h(:, 3), x));

%% Erwthma 3.4

figure(2)
subplot(4, 4, 1); plot(1:size(s5(1:1299)), s5(1:1299), 1:size(s5(1:1299)), y1(1:1299));
subplot(4, 4, 2); plot(1:size(s5(1300:2350)), s5(1300:2350), 1:size(s5(1300:2350)), y1(1300:2350));
subplot(4, 4, 3); plot(1:size(s5(2351:3429)), s5(2351:3429), 1:size(s5(2351:3429)), y1(2351:3429));
subplot(4, 4, 4); plot(1:size(s5(3430:4500)), s5(3430:4500), 1:size(s5(3430:4500)), y1(3430:4500));
subplot(4, 4, 5); plot(1:size(s5(4501:6249)), s5(4501:6249), 1:size(s5(4501:6249)), y1(4501:6249));
subplot(4, 4, 6); plot(1:size(s5(6250:8600)), s5(6250:8600), 1:size(s5(6250:8600)), y1(6250:8600));
subplot(4, 4, 7); plot(1:size(s5(8601:9599)), s5(8601:9599), 1:size(s5(8601:9599)), y1(8601:9599));
subplot(4, 4, 8); plot(1:size(s5(9600:10200)), s5(9600:10200), 1:size(s5(9600:10200)), y1(9600:10200));
subplot(4, 4, 9); plot(1:size(s5(10201:10549)), s5(10201:10549), 1:size(s5(10201:10549)), y1(10201:10549));
subplot(4, 4, 10); plot(1:size(s5(10550:11850)), s5(10550:11850), 1:size(s5(10550:11850)), y1(10550:11850));
subplot(4, 4, 11); plot(1:size(s5(11851:12879)), s5(11851:12879), 1:size(s5(11851:12879)), y1(11851:12879));
subplot(4, 4, 12); plot(1:size(s5(12800:13350)), s5(12800:13350), 1:size(s5(12800:13350)), y1(12800:13350));
subplot(4, 4, 13); plot(1:size(s5(13351:14299)), s5(13351:14299), 1:size(s5(13351:14299)), y1(13351:14299));
subplot(4, 4, 14); plot(1:size(s5(14300:15300)), s5(14300:15300), 1:size(s5(14300:15300)), y1(14300:15300));
subplot(4, 4, 15); plot(1:size(s5(15301:16819)), s5(15301:16819), 1:size(s5(15301:16819)), y1(15301:16819));
subplot(4, 4, 16); plot(1:size(s5(16820:18750)), s5(16820:18750), 1:size(s5(16820:18750)), y1(16820:18750));
legend('Original Speech Signal', 'Pre-emphasised Speech Signal');

%% Erwthma 3.5

listen_ = zeros(53140, 1);
listen_(1:24570) = s5; listen_(28571:end) = y1; 
sound(listen_);
%%