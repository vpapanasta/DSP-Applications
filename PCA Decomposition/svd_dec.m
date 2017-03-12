%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SVD Decomposition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

mode = input('\n For processing with "100-frames" grouping press "1". Else press "2": ');
filename = input(' Choose a file! \n boostrap, campus or lobby ? : ','s');
nonz = input('\n10 or 3 non-zero eigenvalues ? : ');

load(filename,'-mat'); % Load .mat sequence to Workspace

sz = size(video);
N = sz(1, 1)*sz(1, 2); % # of pixels per frame
T = sz(1, 3); % # of frames
% Init the matrix of retrieved sequence
new_video = zeros(sz(1, 1), sz(1, 2), 800);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(mode == 2) % Normal processing
    
    X = zeros(T, N); % Init matrix X 

    % Create the new formation of the data. matrix X (TxN)
    for i = 1 : sz(1, 3)
        temp = video(:, :, i);
        X(i, :) = temp(1:1:end);
    end

    %SVD Decomposition
    [U, S, V] = svd(X(1:800, :), 'econ');

    % Eigenvalues nihilism
    sz1 = size(S);
    dd = ones(800, sz1(1, 2));
    dd(logical(eye(size(dd)))) = 0;
    step = 1 : nonz;
    dd(step, step) = 1;
    S = S .* dd; 

    % Compose the new data sequence, matrix X_new
    X_new = U * S * V'; 

    % Create the video formation
    for i = 1 : 800
        temp(1:1:end) = X_new(i, :);
        new_video(:, :, i) = temp;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
else % Processing with "100-frames" grouping
    
    X = zeros(100, N, 8); % Init matrix X
    
    % Create the new formation of the data. 8 matrices X(100xN)
    for j = 0 : 7
        for i = (j*100 + 1) : (j*100 + 100)
           temp = video(:, :, i);
           X((i - j*100), :, (j+1)) = temp(1:1:end); 
        end   
    end
    
    % For each 100xN matrix
    for k = 1 : 8
        %SVD Decomposition
        [U, S, V] = svd(X(:, :, k), 'econ');
        
        % Eigenvalues nihilism
        sz1 = size(S);
        dd = ones(100, sz1(1, 2));
        dd(logical(eye(size(dd)))) = 0;
        step = 1 : nonz;
        dd(step, step) = 1;
        S = S .* dd;

        % Compose the new data sequence
        X(:, :, k) = U * S * V'; 
    end
    
    % Create the video formation
    for j = 0 : 7
        for i = 1 : 100
            temp(1:1:end) = X(i, :, (j+1));
            new_video(:, :, (j*100 + i)) = temp;
        end   
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

implay(video); % Play old video
implay(new_video); % Play new video