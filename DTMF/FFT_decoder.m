%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT Decoder for the DTMF key signal %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all;

rf = [0 697 770 852 941]; % Row frequencies
cf = [0 1209 1336 1477]; % Column frequencies
index = [0 0]; % Vector of the two frequencies indexes
max_fr = [0 0]; % Vector for the two max frequencies
index_key = [0 0]; % Vector for index key in map table
mapping = [-1 -1 -1 -1; -1 1 2 3; -1 4 5 6;  % Mapping table
           -1 7 8 9; -1 10 0 11];

% Generated DTMF signal from Simulink
x = simout.signals.values(1:480, 1); 
% Calculate |FFT^2|
Y = abs(fft(x, 128).*fft(x, 128));

% Find the indexes of the 2 different max frequencies
[fft_value, index(1)] = max(Y);
Y(index(1), 1) = -1;
for i = 1:1:2 
    if(max(Y) < fft_value)
        [fft_value, index(2)] = max(Y);
    else
        [fft_value, index(2)] = max(Y);
        Y(index(2), 1) = -1;
    end
end

% Calculate frequency = index*fs/N
max_fr = index.*(8000/128);

% Sort frequencies
max_fr = sort(max_fr);
max_fr(1) = max_fr(1) - 50; 

% Calculate the absolute differences from the frequencies
% of vectors rf and cf 
for i = 1:1:5
    rf(i) = abs(rf(i) - max_fr(1));
end

for i = 1:1:4
    cf(i) = abs(cf(i) - max_fr(2));
end

% Find the min diffences and its indexes. (Column & row frequencies)
[index(1), index_key(1)] = min(rf);
[index(2), index_key(2)] = min(cf);
       
key = mapping(index_key(1), index_key(2)); % Map the pressed key
fprintf('The pushed key is: %d \n', key);
