close all
clc
corcoef=0;
e_measure='cor1';
% read all the images
cd 'Archive/training_images/'
tiffFiles = dir('*.tif');
K = length(tiffFiles)

for i=1:K
    file = tiffFiles(i).name;
    img(:,:,i) = im2double(imread(file));
    img_temp=img(:,:,i);
    img_vec(:,i)=img_temp(:);
    
    subplot(7,7,i);
    imshow(img_temp);
end
cd ../../

%% mean of all eigenfaces *******m_c********
m_c=mean(img_vec,2);
% substraction of the mean and the creation of eigenfaces *******v_i=c_i-m_c********
c=img_vec-m_c*ones(1,size(img_vec,2));
if corcoef==1
    n=diag(1./sqrt(sum(c.^2)));
    c=c*n;
end
k=7;
[u,g,p]=svds(c',k);

%% forming distancies in the space of features
W(1:K,1:k) =(p(:,1:k)'*c(:,1:K))';
%pseudo-mapping
x=p(:,1)'*c(:,1:K);
y=p(:,2)'*c(:,1:K);
z=p(:,3)'*c(:,1:K);
figure(2);subplot(2,2,1)
plot3(x,y,z,'ok');
for i=1:K
    text(x(i),y(i),z(i),sprintf('%d',i));
end
grid on
hold
%% Recognition of a random image
testid=int8(rand*K);
while testid==0
    testid=int8(rand*K);
end
testim=im2double(imread(sprintf('Archive/testing_images/s%d.2.tif',testid)));
test_im_vec=testim(:)-m_c;
if corcoef==1
    test_im_vec=test_im_vec/norm(test_im_vec);
end
w_test(1:k) = p(:,1:k)'*test_im_vec;

x=p(:,1)'*test_im_vec;
y=p(:,2)'*test_im_vec;
z=p(:,3)'*test_im_vec;
plot3(x,y,z,'*r');
text(x,y,z,'!!!');
hold
if strcmp(e_measure,'cor')
    e=W*w_test';
    [~, i_m]=max(e);
else
    e=sum((W'-w_test'*ones(1,K)).^2);
    [~,i_m]=min(e);
end
e(i_m)
subplot(2,2,2);stem(e);xlabel('error plot');
cd 'Archive/training_images/'
subplot(2,2,3);imshow(testim);xlabel('Query Image');
subplot(2,2,4);imshow(imread(tiffFiles(i_m).name));xlabel('Recognized Image');
cd ../../