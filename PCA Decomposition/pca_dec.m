%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PCA Decomposition %%%
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

     %%%%%%%%%%%%%%%%%%% PCA Decomposition %%%%%%%%%%%%%%%%%%%
     
     % Subtract each column mean value
     m = repmat(mean(X,1), T, 1);
     X_0 = X - m;

     R = X_0*X_0'; % TxT matrix R
     
     % SVD Decomposition of R
     [U, SSt, Ut] = svd(R, 'econ');
     
     S1 = sqrt(SSt);
    
     V1 = X_0'*U*S1^(-1);
    
     % Eigenvalues nihilism
     sz1 = size(S1);
     dd = ones(800, sz1(1, 2));
     dd(logical(eye(size(dd)))) = 0;
     step = 1 : nonz;
     dd(step, step) = 1;
     S1_new = S1(1:800, :) .* dd; 
     
     % Compose the new data sequence, matrix X_new
     X_new = U(1:800, 1:800) * S1_new * V1'; 
     % Add each column mean value
     X_new = X_new + m(1:800, :);      
      
     % Create the video formation
     for i = 1 : 800
         temp(1:1:end) = X_new(i, :);
         new_video(:, :, i) = temp;
     end
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
else % Processing with "100-frames" grouping
    
    X = zeros(100, N, 8); % Init matrix X
    X_new = zeros(100, N, 8); % Init matrix X_new
    
    % Create the new formation of the data. 8 matrices X(100xN)
    for j = 0 : 7
        for i = (j*100 + 1) : (j*100 + 100)
           temp = video(:, :, i);
           X((i - j*100), :, (j+1)) = temp(1:1:end); 
        end   
    end
    
    % For each 100xN matrix
    for k = 1 : 8
         % Subtract each column mean value
         m = repmat(mean(X(:, :, k),1), T, 1);
         X_0 = X(:, :, k) - m(1:100, :);

         R = X_0*X_0';

         % SVD Decomposition of R
         [U, SSt, Ut] = svd(R, 'econ');

         S1 = sqrt(SSt);

         V1 = X_0'*U*S1^(-1);

         % Eigenvalues nihilism
         sz1 = size(S1);
         dd = ones(100, sz1(1, 2));
         dd(logical(eye(size(dd)))) = 0;
         step = 1 : nonz;
         dd(step, step) = 1;
         S1_new = S1 .* dd; 

         % Compose the new data sequence, matrix X_new
         X_new(:, :, k) = U * S1_new * V1'; 
         % Add each column mean value
         X_new(:, :, k) = X_new(:, :, k) + m(1:100, :);        
    end
    
    % Create the video formation
    for j = 0 : 7
        for i = 1 : 100
            temp(1:1:end) = X_new(i, :, (j+1));
            new_video(:, :, (j*100 + i)) = temp;
        end   
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

implay(video); % Play old video
implay(new_video); % Play new video
