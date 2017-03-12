clear all; clc;
start = input('Start of signal part: ');
stop = input('Stop of signal part: ');

%% Erwthma 5
D = load('speech_signal-1.mat');
fs = 8000; % Sampling frequency

%% Erwthma 5.2.1
% s = D.s5(17000:17800, 1);
s = D.s5(start:stop, 1);

sz = size(s);
N = sz(1, 1);

%% 1
p = 12; % Order linear predictor
ham = hamming(N); % Hamming filter
s_ham = s.*ham;

%%% Pre-emphasis %%%
% Bb = [1 -0.98]; Aa = 1;
% s_ham = filter(Bb, Aa, s_ham);

[A,g] = lpc(s_ham, p);

%% 2
AH = freqz([1 A], 1, fs); % Frequency  response of A(z)
AH_m = AH.*AH;

S = freqz(1, [1 A], fs); % Frequency  response of speech signal
S_m = S.*S;

w = 0:pi/fs:pi;
w = w(1, 1:fs);

figure(1);
plot(w./pi, 20*log10(S_m), w./pi, 20*log10(AH_m), 'r');
legend('FR of speech signal', 'FR of prediction error filter');
xlabel('Normalized Frequencies');
ylabel('Magnitude |dB|');

figure(2); zplane([1 A], 1); % Zeros of A(z)
title('Zeros of the error prediction filter');
figure(3); zplane(1, [1 A]); % Poles of H(z)
title('Poles of Speech model');

%% 3 
s_tild = zeros(N, 1);
% Estimate signal
%{
% Manual estimation
for n = 1:N
    for i = 1:p
       if(n-i<=0)
           s_tild(n, 1) = s_tild(n, 1); 
       else    
           s_tild(n, 1) = s_tild(n, 1) - A(1, i+1)*s_ham(n-i);
       end
    end
end
%}
s_tild = filter([0 -A(2:end)], 1, s_ham);

f = s_ham - s_tild; % Prediction error sequense

figure(4);
plot(1:N, s, 1:N, s_ham, '-o', 1:N, f, 'r-*');
legend('Original signal', 'Windowed signal', 'Prediction error sequense');

%% 4
rff = zeros(N, 1);

%[acs,lags] = xcorr(,'coeff');

for k = 0:N-1
    ff = 0;
    for n = 1:N-k
        ff = ff + f(n)*f(n+k);
    end
    rff(k+1, 1) = (1/(N-k))*ff;
    if(k>0) % Normalization
        rff(k+1, 1) = rff(k+1, 1)/rff(1, 1);
    end
end

[peak, fund_f] = max(abs(rff(2:N)));

% Compare peak with threshold 
if (peak < 0.3)
    u = wgn(N, 1, 0);
else
    u = cos(2*pi*fund_f*w)';
end

% Calculate E
E = 0;
E = sum(f.^2);

% Calculate G
sum_u = 0;
for i = 1:N
    sum_u = sum_u + u(i, 1);
end
G = sqrt(E/sum_u); % Calculate G